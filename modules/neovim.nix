{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      git
      ripgrep
      fd
      gcc
      gnumake
      unzip
      curl
      fzf
      # Language Servers
      gopls
      lua-language-server
      typescript-language-server
      typescript
    ];
    initLua = builtins.readFile ./nvim/init.lua;
  };
}
