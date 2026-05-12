## changelog
* **v.0.1.3**: +CUPS printing service, +`gnupg`
* **v.0.1.2**: +`host.nix` module
* **v.0.1.1**: implemented flake
```
/etc/nixos
.
├── configuration.nix   # top level
├── flake.lock          # auto-gen
├── flake.nix           # system flake
├── hardware-configuration.nix  # auto-gen
├── host.nix        # system options, network, services, fonts
├── packages.nix    # system packages
├── README.md
├── update.sh       # system update script, alias=update
└── zsh.nix         # zsh home-manager options
```
```
operator@uss-enterprise
-----------------------
OS: NixOS 25.11 (Xantusia) x86_64
Kernel: Linux (*latest*)
Packages: 2151 (nix-system), 401 (nix-user)
DE: KDE Plasma
WM: KWin (Wayland)
CPU: AMD Ryzen 5 7600X3D (12) @ 4.73 GHz
GPU: GTX 1070 [Discrete]
Memory: 31.06 GiB
Swap: 31.53 GiB
```

## TODO
* [x] ~~setup home-manager~~
* [x] ~~setup flake~~
* [ ] modularize *further*
    * [x] ~~host.nix~~
    * [ ] home.nix      # finish and import
    * [ ] network.nix
    * [ ] services.nix

<img width="1024" height="768" alt="image" src="https://github.com/user-attachments/assets/81b28e0e-4f38-4833-a146-3f04cdf47dd4" />
