{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # applications
    btop
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
    qdirstat
    weather
    unzip
    yt-dlp
    wavemon
    zip

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

### this lives in host.nix
#   fonts.packages = with pkgs; [
#     nerd-fonts.agave
#     nerd-fonts.fira-code
#     nerd-fonts.hack
#     nerd-fonts.iosevka
#     nerd-fonts.jetbrains-mono
#     nerd-fonts.meslo-lg
#     nerd-fonts.victor-mono
#     nerd-fonts.zed-mono
#     cozette dina-font
#     liberation_ttf
#     noto-fonts
#     noto-fonts-color-emoji
#   ];

#   fonts = {
#     #enableDefaultPackages = false;
#     packages = with pkgs; [
#     nerd-fonts.agave
#     nerd-fonts.fira-code
#     nerd-fonts.hack
#     nerd-fonts.iosevka
#     nerd-fonts.jetbrains-mono
#     nerd-fonts.meslo-lg
#     nerd-fonts.victor-mono
#     nerd-fonts.zed-mono
#     cozette dina-font
#     liberation_ttf
#     noto-fonts
#     noto-fonts-color-emoji
#     ];
#     fontconfig = {
#     enable = true;
#     useEmbeddedBitmaps = true;   # for Firefox emoji rendering
#     };
#   };
}
