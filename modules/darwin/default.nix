{ config, pkgs, ... }:

{
  imports = [
    ./aerospace.nix
  ];

  programs.ssh.includes = [
    "~/.orbstack/ssh/config"
  ];

  home.packages = [
    pkgs.unnaturalscrollwheels
    pkgs.orbstack

  ];
}
