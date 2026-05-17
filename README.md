```
                     __________      _____            _____             
____  __________________  ____/________  /_______________(_)___________ 
_  / / /_  ___/_  ___/_  __/  __  __ \  __/  _ \_  ___/_  /__  ___/  _ \
/ /_/ /_(__  )_(__  )_  /___  _  / / / /_ /  __/  /   _  / _(__  )/  __/
\__,_/ /____/ /____/ /_____/  /_/ /_/\__/ \___//_/    /_/  /____/ \___/ 

```

## changelog
* **v.0.1.4**: +`home.nix`, +`networking.nix`
* **v.0.1.3**: +CUPS printing service, +`gnupg`
* **v.0.1.2**: +`host.nix` module
* **v.0.1.1*: +flake

## structure
```
/etc/nixos
.
├── configuration.nix   # top level config
├── flake.loc
├── flake.nix
├── hardware-configuration.nix  # auto-gen
├── home.nix
├── host.nix
├── packages.nix
├── networking.nix
├── README.md
├── update.sh           # alias=update
└── zsh.nix
```

## specs
```
operator@uss-enterprise
-----------------------
OS: NixOS 25.11 (Xantusia) x86_64
Kernel: Linux (latest)
DE: KDE Plasma
WM: KWin (Wayland)
CPU: AMD Ryzen 5 7600X3D (12) @ 4.73 GHz
GPU: GTX 1070 [Discrete]
Memory: 32 GiB
Swap: 32 GiB
```

## TODO
* [x] ~~setup home-manager~~
* [x] ~~setup flake~~
* [ ] modularize *further*
    * [x] ~~host.nix~~
    * [x] ~~home.nix~~
    * [x] ~~networking.nix~~
    * [ ] services.nix

<img width="1024" height="768" alt="image" src="https://github.com/user-attachments/assets/81b28e0e-4f38-4833-a146-3f04cdf47dd4" />
