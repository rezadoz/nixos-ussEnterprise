{ config, pkgs, ... }:

{
#   imports = [
#     #
#   ];

  home.username = "operator";
  home.homeDirectory = "/home/operator";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR  = "nvim";
    VISUAL  = "nvim";
    PAGER   = "less";
    MANPAGER = "nvim +Man!";
  };

  home.packages = with pkgs; [
    #
  ];

  home-manager.users.operator = { pkgs, ... }: {
  #home.packages = [ pkgs.atool pkgs.httpie ];
  #programs.zsh.enable = true;
    imports = [ ./zsh.nix ./home.nix ];
    home.stateVersion = "25.11"; # DO NOT EDIT
  };

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
    withRuby   = false;
    withPython3 = false;
  };

  #programs.home-manager.enable = true;
}
