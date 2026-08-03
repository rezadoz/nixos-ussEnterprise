{ config, pkgs, ... }:

{
  ############################################################
  # Printing (CUPS)
  ############################################################
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];
    # ^ only needed as a fallback; try driverless first and you can drop these later
  };

  # mDNS / Bonjour so the printer is discoverable on the LAN
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  ############################################################
  # Sound (PipeWire)
  ############################################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  ############################################################
  # Bluetooth applet (hardware.bluetooth lives in host.nix)
  ############################################################
  services.blueman.enable = true;

  ############################################################
  # Jellyfin
  ############################################################
  services.jellyfin = {
    enable = true;
    openFirewall = true;      # opens 8096 (http) and 8920 (https)
    user = "jellyfin";
    group = "jellyfin";
    # dataDir, cacheDir, configDir default under /var/lib/jellyfin
    # NVENC/NVDEC transcoding works via hardware.graphics + nvidia (host.nix);
    # the service already ships jellyfin-ffmpeg, no extra packages needed.
  };

  ############################################################
  # nginx
  # Reasonable hardened defaults. Add virtualHosts as needed.
  ############################################################
  services.nginx = {
    enable = true;
    recommendedGzipSettings  = true;
    recommendedOptimisation  = true;
    recommendedProxySettings = true;
    recommendedTlsSettings   = true;
    virtualHosts."localhost" = {
      root = "/var/www";
      locations."/" = {
        tryFiles = "$uri $uri/ /index.html";
      };
    };
    # Example reverse-proxy in front of Jellyfin. Uncomment
    # and edit the serverName when you're ready.
    #
    # virtualHosts."jellyfin.local" = {
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:8096";
    #     proxyWebsockets = true;
    #   };
    # };
  };

  ############################################################
  # OpenSSH
  ############################################################
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;   # set false once you've added keys
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
    ports = [ 22 ];
  };
}
