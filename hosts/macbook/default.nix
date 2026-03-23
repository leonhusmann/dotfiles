{ config, pkgs, ... }:

{
  imports = [
    ../../profiles/personal.nix
    ../../profiles/work.nix
    ../../modules/darwin
    ../../themes
  ];

  my.git.userEmail = "leon.husmann@check24.de";

  home.username = "leon.husmann";
  home.homeDirectory = "/Users/leon.husmann";

  home.stateVersion = "25.11";

  home.file = {};

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
  };

  programs.home-manager.enable = true;
}
