{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
    };
    extraConfig = ''
      syntax on
      set clipboard=unnamed
    '';
  };
}
