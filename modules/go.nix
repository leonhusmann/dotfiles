{ config, pkgs, ... }:

{
  programs.go = {
    enable = true;
    package = pkgs.go_1_26;
    env = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${config.home.homeDirectory}/go/bin";
    };
  };
}
