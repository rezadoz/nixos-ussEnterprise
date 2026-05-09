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
    retroarch
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
    file
    hunspellDicts.en-us-large
    imagemagick
    lsd
    ripgrep
    rsclock
    nix-output-monitor
    nmap
    pv
    qdirstat
    tree
    weather
    unzip
    yt-dlp
    wavemon
    zip

    unstable.kdePackages.konsole
    #unstable.kdePackages.dolphin
    #unstable.kdePackages.kate
    #unstable.kdePackages.kwrited
    # add more KDE apps from unstable as desired, e.g.:
    #unstable.kdePackages.okular
    #unstable.kdePackages.gwenview
    #unstable.kdePackages.ark
    #unstable.kdePackages.spectacle

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
