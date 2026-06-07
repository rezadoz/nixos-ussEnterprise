{
  description = "uss-enterprise NixOS configuration";

  inputs = {
    # Primary channel — now tracking the rolling unstable branch.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Latest stable (26.05 "Yarara") kept available via an overlay as `pkgs.stable.*`.
    # Use this prefix when you want a package pinned to stable instead of unstable.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    # home-manager that tracks nixpkgs *unstable* — this is the `master` branch.
    # (The `release-XX.YY` branches are for the matching *stable* nixpkgs.)
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.uss-enterprise = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          # Overlay that adds `pkgs.stable` (26.05) everywhere in the system
          ({ config, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];
          })

          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            # Pass `inputs` down to home-manager modules if you ever need it there
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
}
