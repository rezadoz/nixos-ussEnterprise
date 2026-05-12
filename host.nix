{ config, pkgs, lib, ... }:

{
  ############################################################
  # Filesystems
  ############################################################
  fileSystems."/run/media/bread/cabin" = {
    device = "/dev/disk/by-uuid/3eb94e48-ca1e-446b-ab5e-a68def1a6c99";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5"
      "x-gvfs-show"   # makes it appear nicely in file managers
    ];
  };

  ############################################################
  # Swap
  # NixOS does not support a truly "dynamic" swapfile, but you
  # can approximate it with zram (compressed RAM swap that
  # grows as needed) AND a fixed-size on-disk swapfile as a
  # fallback. With 32 GB RAM, 16 GB on-disk swap is plenty
  # (and enough for hibernation if you ever want it).
  ############################################################
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;       # MB → 16 GB
    }
  ];

  # zram: fast compressed swap in RAM, sized as a percent of RAM.
  # This is the closest thing to "dynamic" swap on Linux.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;       # up to 50% of RAM as compressed swap
  };

  ############################################################
  # Bluetooth
  ############################################################
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;  # battery reporting, etc.
      };
    };
  };
  services.blueman.enable = true;

  ############################################################
  # NVIDIA (proprietary)
  ############################################################
  # Required for the proprietary driver
  nixpkgs.config.allowUnfree = true;

  # Make sure the kernel uses the nvidia DRM modeset path
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;       # for Steam / 32-bit games
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # Power management — leave off unless you specifically
    # need suspend/resume fixes; it's still beta-ish.
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the proprietary kernel module (not the open one).
    # Flip to true if you have a Turing+ card and want the
    # open-source kernel module.
    open = false;

    # nvidia-settings GUI in the system menu
    nvidiaSettings = true;

    # Pin to the production driver. Change to `beta`,
    # `stable`, or a specific version if needed.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  ############################################################
  # Services: Jellyfin
  ############################################################
  services.jellyfin = {
    enable = true;
    openFirewall = true;      # opens 8096 (http) and 8920 (https)
    user = "jellyfin";
    group = "jellyfin";
    # dataDir, cacheDir, configDir default under /var/lib/jellyfin
  };

  # Hardware-accelerated transcoding via NVENC/NVDEC
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  ############################################################
  # Services: nginx
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
  # Services: OpenSSH
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

  ############################################################
  # Fonts
  ############################################################
  fonts = {
    #enableDefaultPackages = false;
    packages = with pkgs; [
      nerd-fonts.agave
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.victor-mono
      nerd-fonts.zed-mono
      cozette
      dina-font
      liberation_ttf
      #noto-fonts   # I don't like their braille glyphs
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;   # for Firefox emoji rendering
    };
  };

  ############################################################
  # Networking
  #
  # NOTE: 10.0.10.0 is the *network address* of a /24 subnet,
  # not a valid host address. Using 10.0.10.10 instead — change
  # to whatever free host address you actually want.
  #
  # NetworkManager is enabled in configuration.nix; it will
  # honor the static address declared here on the named iface.
  # Replace `enp4s0` with your real interface (run `ip a`).
  ############################################################
  networking = {
    hostName = "uss-enterprise";
    networkmanager.enable = true;
    # Disable DHCP globally; we'll set per-interface below.
    useDHCP = lib.mkDefault false;

    # Static IP. Replace interface name with your NIC.
    interfaces.wlp9s0.ipv4.addresses = [{
      address = "10.10.10.10";
      prefixLength = 24;
    }];

    defaultGateway = "10.0.0.1";
    nameservers    = [ "1.1.1.1" "9.9.9.9" ];

    # Kernel-level IP forwarding (lets this box route packets
    # between interfaces — useful for VPN gateways, containers,
    # libvirt bridges, etc.). NOT the same as router port-forwarding.
    nat.enable = false;  # flip on if you actually want NAT
    firewall = {
      enable = true;
      # Jellyfin (8096/8920) and SSH (22) are opened by their
      # respective services above via openFirewall.
      allowedTCPPorts = [ 80 443 ];   # nginx
      allowedUDPPorts = [ ];
    };
  };

  # Enable IPv4 + IPv6 forwarding via sysctl
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}

