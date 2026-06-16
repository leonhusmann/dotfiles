{ lib, pkgs, ... }:

{
  imports = [
    ../modules/ideavim.nix
  ];

  my.ssh.extraHosts = {
    "stash.check24.de" = {
      IdentityFile = "~/.ssh/c24_bitbucket";
      User = "leon.husmann";
    };

    "bitbucket.check24.de" = {
      IdentityFile = "~/.ssh/c24_bitbucket";
      User = "leon.husmann";
    };

    "jenkins-* hocore-* mdma-* ds-* img-* lb-* bo-* ho-* pa-* uti* hoapi-*" = {
      User = "leon.husmann";
      Port = 42022;
      IdentityFile = "~/.ssh/c24_cluster";
      ControlMaster = "auto";
      ControlPath = "~/.ssh/socket-%r@%h:%p";
      ControlPersist = "30m";
    };
  };

  home.packages = [
    pkgs.mkcert
    pkgs.nss
    pkgs.k6
    pkgs.buf
    pkgs.claude-code
    pkgs.jetbrains.goland
    pkgs.jetbrains.phpstorm
    pkgs.openvpn
    pkgs.code-cursor
    pkgs.cursor-cli
    pkgs.zoom-us
    pkgs.go-task
    pkgs.slack
    pkgs.tinyproxy
  ];
}
