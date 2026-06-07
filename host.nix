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

    # Pascal (GTX 1070) was dropped by the 590 driver series, so pin to the
    # 580 LTSB branch — the last one that still drives this card.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
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
}

