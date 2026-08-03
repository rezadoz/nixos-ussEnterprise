{ config, pkgs, ... }:

# Home-manager module for the `operator` user.
# Wired up in configuration.nix via `home-manager.users.operator = import ./home.nix;`

{
  imports = [
    ./zsh.nix
  ];

  home.username = "operator";
  home.homeDirectory = "/home/operator";
  home.stateVersion = "25.11"; # DO NOT EDIT

  home.sessionVariables = {
    EDITOR   = "nvim";
    VISUAL   = "nvim";
    PAGER    = "less";
    MANPAGER = "nvim +Man!";
  };

  home.packages = with pkgs; [
    #
  ];

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user.name  = "rezadoz";
      user.email = "rezadoz@gmail.com";
      init.defaultBranch = "master";
      pull.rebase = true;
      core.editor = "nvim";
      diff.tool = "nvimdiff";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias  = false;
    vimAlias = false;
    withRuby    = false;
    withPython3 = false;
  };

  # Let home-manager manage itself (useful for `home-manager` CLI)
  #programs.home-manager.enable = true;
}
