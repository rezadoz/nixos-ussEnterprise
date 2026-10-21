{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # applications
    btop-cuda
    catnip
    cool-retro-term
#     discord
    discordo
    feh
    fish
    ffmpeg
    geeqie
    gimp gimpPlugins.gmic
    imgbrd-grabber
    kaidan    # xmpp (gui)
    libreoffice-qt6
    mpv
    obs-studio
    qbittorrent
#     qemu_full
#     quickemu # qemu wrapper
#     retroarch-full
    pcsx2
    profanity # xmpp (tui)
    psi-plus # xmpp (gui)
    #steam # redudant, using `programs.steam.enable = true;`
    protonup-qt
    tor-browser
    tlrc # tldr
    #virtualbox
    wineWow64Packages.waylandFull
    winetricks
    yazi
    zathura
    zapzap # whatapp
    zsh zsh-powerlevel10k

    # utilities
    _7zz-rar unrar
    bat
    bk  # epub reader
    fastfetch
    figlet
    file
    fzf
    gnupg
    hunspellDicts.en-us-large
    imagemagick
    lolcat
    lsd
    ripgrep
    rsclock
#     mullvad   # enabled in services
#     mullvad-vpn
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
    android-tools
#     androidsdk
    autoconf
    automake
    binutils
    clang
    cmake
    curl
    gcc
    gdb
    git
    gh
    gnumake
    go
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

    # my own packages
    (callPackage ./jogger.nix { })
    (callPackage ./photocraft.nix { src = inputs.photocraft; })
  ];
}
