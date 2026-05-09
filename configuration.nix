# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
      ./hardware-configuration.nix
      ./host.nix
      ./packages.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  /* this now lives in host.nix
  networking.hostName = "uss-enterprise";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;*/

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.operator = {
    isNormalUser = true;
    description = "operator";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  home-manager.users.operator = { pkgs, ... }: {
  #home.packages = [ pkgs.atool pkgs.httpie ];
  #programs.zsh.enable = true;
    imports = [ ./zsh.nix ];
    home.stateVersion = "25.11"; # DO NOT EDIT
  };

  programs.firefox.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;
    /*configure = {
      customRC = ''
        set runtimepath^=${pkgs.vimPlugins.jellybeans-vim}
        colorscheme jellybeans
        set number
        set cc=80
        set list
        set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
        if &diff
          colorscheme blue
        endif
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ ctrlp ];
      };
    };*/
  };
  programs.steam.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "25.11"; # DO NOT EDIT

}
