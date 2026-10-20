{ config, pkgs, lib, ... }:

############################################################
# XMPP (Prosody) — LAN only
#
#   JID domain : uss-enterprise.local  (already published by avahi)
#   group chat : conference.uss-enterprise.local
#   uploads    : https://uss-enterprise.local:5281/file_share/
#
# No federation (s2s is disabled, 5269 stays closed), no in-band
# registration. Make accounts by hand:
#
#   sudo prosodyctl adduser operator@uss-enterprise.local
#
# TLS: a private LAN CA + server cert is generated on first boot
# into /var/lib/prosody/certs (see prosody-lan-cert below). To
# make Kaidan on this box trust it, copy the *public* CA cert
# into the repo and rebuild:
#
#   sudo mkdir -p /etc/nixos/certs
#   sudo cp /var/lib/prosody/certs/ca.crt /etc/nixos/certs/xmpp-lan-ca.crt
#   sudo git -C /etc/nixos add certs/xmpp-lan-ca.crt   # flakes ignore untracked files
#   rebuild
#
# Other devices: import that same ca.crt as a trusted CA.
############################################################

let
  domain    = "${config.networking.hostName}.local";
  mucDomain = "conference.${domain}";
  upDomain  = "upload.${domain}";

  certDir = "${config.services.prosody.dataDir}/certs";
  caFile  = ./certs/xmpp-lan-ca.crt;

  # Same idea as sshd in services.nix: only the LAN may connect.
  lanRanges4 = [ "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" ];
  lanRanges6 = [ "fe80::/10" "fc00::/7" ];  # link-local + ULA (mDNS hands these out too)
  xmppPorts  = [ 5222 5281 ];               # c2s, https (file uploads)
in
{
  services.prosody = {
    enable = true;

    admins = [ "operator@${domain}" ];
    allowRegistration = false;

    # One cert (with SANs for every subdomain) serves all hosts.
    ssl = {
      cert = "${certDir}/server.crt";
      key  = "${certDir}/server.key";
    };

    # Defining any vhost replaces the module's default `localhost` one.
    virtualHosts.lan = {
      inherit domain;
      enabled = true;
      ssl = config.services.prosody.ssl;
    };

    muc = [{
      domain = mucDomain;
      name = "uss-enterprise rooms";
      restrictRoomCreation = "local";   # any account on this server, nobody else
      roomDefaultPublic = false;
    }];

    # Served from the main domain so clients only need the one mDNS name.
    httpFileShare = {
      domain    = upDomain;
      http_host = domain;
      size_limit    = 100 * 1024 * 1024;   # 100 MB per file
      daily_quota   = 1024 * 1024 * 1024;  # 1 GB per user per day
      expires_after = "1 month";
    };

    # HTTPS only for uploads; no plaintext HTTP listener.
    httpPorts  = [ ];
    httpsPorts = [ 5281 ];

    extraConfig = ''
      -- LAN-only box: never federate.
      modules_disabled = { "s2s" }

      https_ssl = {
        certificate = "${certDir}/server.crt";
        key = "${certDir}/server.key";
      }
    '';
  };

  ############################################################
  # Self-signed LAN CA + server cert, created once if missing.
  # Delete /var/lib/prosody/certs to regenerate (then re-copy ca.crt).
  ############################################################
  systemd.services.prosody-lan-cert = {
    description = "Generate LAN TLS certificate for Prosody";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      StateDirectory = "prosody";   # make sure /var/lib/prosody exists first
    };
    path = [ pkgs.openssl pkgs.coreutils ];
    script = ''
      set -eu
      dir=${certDir}
      if [ -s "$dir/server.crt" ] && [ -s "$dir/server.key" ] && [ -s "$dir/ca.crt" ]; then
        exit 0
      fi

      install -d -m 0750 -o prosody -g prosody "$dir"
      umask 077
      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT

      # CA (10 years) — this is the file devices import
      openssl req -x509 -new -nodes -newkey ec -pkeyopt ec_paramgen_curve:P-256 \
        -keyout "$dir/ca.key" -out "$dir/ca.crt" -days 3650 \
        -subj "/CN=${config.networking.hostName} LAN CA" \
        -addext "basicConstraints=critical,CA:TRUE,pathlen:0" \
        -addext "keyUsage=critical,keyCertSign,cRLSign"

      # Server cert (825 days, the most Apple clients will accept)
      openssl req -new -nodes -newkey ec -pkeyopt ec_paramgen_curve:P-256 \
        -keyout "$dir/server.key" -out "$tmp/server.csr" \
        -subj "/CN=${domain}"
      cat > "$tmp/ext.cnf" <<EOF
      basicConstraints=critical,CA:FALSE
      keyUsage=critical,digitalSignature
      extendedKeyUsage=serverAuth,clientAuth
      subjectAltName=DNS:${domain},DNS:${mucDomain},DNS:${upDomain},DNS:*.${domain}
      EOF
      openssl x509 -req -in "$tmp/server.csr" -CA "$dir/ca.crt" -CAkey "$dir/ca.key" \
        -CAcreateserial -out "$dir/server.crt" -days 825 -extfile "$tmp/ext.cnf"

      chown prosody:prosody "$dir/server.key" "$dir/server.crt" "$dir/ca.crt"
      chmod 0600 "$dir/server.key" "$dir/ca.key"
      chmod 0644 "$dir/server.crt" "$dir/ca.crt"
    '';
  };
  systemd.services.prosody = {
    requires = [ "prosody-lan-cert.service" ];
    after    = [ "prosody-lan-cert.service" ];
  };

  # Trust the LAN CA system-wide once it has been copied into the repo
  # (see header). Until then this is a no-op so the first build works.
  security.pki.certificateFiles = lib.optional (builtins.pathExists caFile) caFile;

  ############################################################
  # Firewall: 5222/5281 from the LAN only (same pattern as ssh)
  ############################################################
  networking.firewall.extraCommands = lib.concatStrings (
    lib.concatMap (port:
      map (net: "iptables -I nixos-fw -p tcp --dport ${toString port} -s ${net} -j nixos-fw-accept\n") lanRanges4
      ++ map (net: "ip6tables -I nixos-fw -p tcp --dport ${toString port} -s ${net} -j nixos-fw-accept\n") lanRanges6
    ) xmppPorts
  );
}
