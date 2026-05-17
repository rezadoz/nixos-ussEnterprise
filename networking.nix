{ config, pkgs, lib, ... }:

{
  ############################################################
  # Networking
  ############################################################
  networking = {
    hostName = "uss-enterprise";
    networkmanager.enable = true;

    # Disable DHCP globally; we'll set per-interface below.
    useDHCP = lib.mkDefault false;

    # Static IP. Replace interface name with your NIC.
    interfaces.wlp9s0.ipv4.addresses = [{
      address = "10.0.0.203";
      prefixLength = 24;
    }];

    defaultGateway = "10.0.0.1";
    nameservers = [ "1.1.1.1" "9.9.9.9" ];

    # Kernel-level IP forwarding (lets this box route packets
    # between interfaces — useful for VPN gateways, containers,
    # libvirt bridges, etc.). NOT the same as router port-forwarding.
    nat.enable = false; # flip on if you actually want NAT

    firewall = {
      enable = true;
      # Jellyfin (8096/8920) and SSH (22) are opened by their
      # respective services in host.nix via openFirewall.
      allowedTCPPorts = [ 80 443 ]; # nginx
      allowedUDPPorts = [ ];
    };
  };

  # Enable IPv4 + IPv6 forwarding via sysctl
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
