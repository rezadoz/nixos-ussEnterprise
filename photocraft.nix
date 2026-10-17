{ lib
, rustPlatform
, pkg-config
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, wayland
, libxkbcommon
, vulkan-loader
, libGL
, xorg
, src
}:

let
  # winit/wgpu dlopen these at runtime, so they must be on LD_LIBRARY_PATH.
  runtimeLibs = [
    wayland
    libxkbcommon
    vulkan-loader
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxcb
  ];
in
rustPlatform.buildRustPackage {
  pname = "photocraft";
  version = "0.9.0";
  inherit src;

  # Local fix: the presets loader in presets/mod.rs never read `export_presets`,
  # so the tree didn't compile and saved export presets would be dropped.
  patches = [ ./photocraft-export-presets.patch ];

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  # Desktop app only. Add "-p" "photocraft-cli" for the CLI too.
  cargoBuildFlags = [ "-p" "photocraft" ];

  # The workspace has 1,700+ tests, some needing downloaded corpora.
  doCheck = false;

  nativeBuildInputs = [ pkg-config makeWrapper copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "photocraft";
      desktopName = "PhotoCraft";
      exec = "photocraft %F";
      icon = "ai.storyteller.photocraft";
      categories = [ "Graphics" "2DGraphics" "RasterGraphics" ];
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/
    wrapProgram $out/bin/photocraft \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
  '';

  meta = {
    description = "Open-source, clean-room Photoshop-style image editor in pure Rust";
    homepage = "https://github.com/storytold/photocraft";
    license = with lib.licenses; [ mit asl20 ];
    mainProgram = "photocraft";
    platforms = [ "x86_64-linux" ];
  };
}
