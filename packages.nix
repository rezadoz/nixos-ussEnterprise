{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # applications
    btop-cuda
    catnip
    feh
    fish
    ffmpeg
    geeqie
    gimp gimpPlugins.gmic
    libreoffice-qt6
    mpv
    qbittorrent
    qemu_full
    quickemu # qemu wrapper
#     retroarch-full
    pcsx2
    #steam # redudant, using `programs.steam.enable = true;`
    protonup-qt
    tlrc # tldr
    #virtualbox
    wineWow64Packages.waylandFull
    winetricks
    yazi
    zathura
    #zapzap # whatapp
    zsh zsh-powerlevel10k

    # utilities
    _7zz-rar unrar
    bat
    fastfetch
    figlet
    file
    gnupg
    hunspellDicts.en-us-large
    imagemagick
    lolcat
    lsd
    ripgrep
    rsclock
    nix-output-monitor
    nmap
    pv
    qdirstat
    termdown
    tree
    weather
    unzip
    yt-dlp
    wavemon
    zip

    kdePackages.partitionmanager

    # dev pkgs
    autoconf
    automake
    binutils
    clang
    cmake
    curl
    gcc
    gdb
    git
    gnumake
    libtool
    llvm
    meson
    ninja
    openssl
    patch
    pkg-config
    python3
    rustup
    stdenv.cc
    wget
  ];
}
