{ config, pkgs, ... }:

# Home-manager module for neovim.
# Imported from home.nix. Generates ~/.config/nvim/init.lua (read-only symlink),
# so edit options here and rebuild instead of editing the file directly.

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias  = false;
    vimAlias = false;
    withRuby    = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      vim-monokai   # monokai colorscheme (crusoexia/vim-monokai)
    ];

    initLua = ''
      local opt = vim.opt

      -- line numbers: absolute, always shown
      opt.number         = true
      opt.relativenumber = false

      -- theme
      opt.termguicolors = true
      opt.background    = "dark"
      vim.cmd.colorscheme("monokai")

      -- indentation (2 spaces, matches the nix files)
      opt.expandtab   = true
      opt.tabstop     = 2
      opt.shiftwidth  = 2
      opt.softtabstop = 2
      opt.smartindent = true

      -- searching
      opt.ignorecase = true
      opt.smartcase  = true
      opt.hlsearch   = true
      opt.incsearch  = true

      -- ui
      opt.cursorline = true
      opt.signcolumn = "yes"
      opt.scrolloff  = 8
      opt.wrap       = false
      opt.splitright = true
      opt.splitbelow = true
      opt.mouse      = "a"

      -- behaviour
      opt.clipboard  = "unnamedplus"  -- share the system clipboard
      opt.undofile   = true           -- persistent undo
      opt.updatetime = 250
    '';
  };
}
