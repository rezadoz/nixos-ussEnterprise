{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.operator = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "25.11";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    home.packages = [ /etc/nixos/packages.nix ];
  };
}
