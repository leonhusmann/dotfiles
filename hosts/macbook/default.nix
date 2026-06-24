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

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
  };

  programs.home-manager.enable = true;

  launchd.agents.home-manager-update = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh" "-c"
        "cd /Users/leon.husmann/Dotfiles && nix flake update && home-manager switch --flake .#macbook && nix-collect-garbage --delete-older-than 7d"
      ];
      StartCalendarInterval = [{ Hour = 7; Minute = 0; }];
      StandardOutPath = "/tmp/hm-update.log";
      StandardErrorPath = "/tmp/hm-update.log";
    };
  };
}
