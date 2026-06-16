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
    pkgs.openfortivpn
    pkgs.code-cursor
    pkgs.cursor-cli
    pkgs.zoom-us
    pkgs.go-task
    pkgs.slack
    pkgs.tinyproxy
    (pkgs.writeShellScriptBin "forti" ''
      set -o nounset
      set -o errexit

      user="leon.husmann"
      password=$(op read "op://Employee/Fortigate VPN/password")
      authFilePrefix="''${HOME}/Library/Caches/check24-forti-vpn.auth"

      rm -f "$authFilePrefix".*
      authFile="$(mktemp "$authFilePrefix.XXXXXXX")"
      trap 'rm -f "$authFile"' EXIT

      echo "username = $user" > "$authFile"
      echo "password = $password" >> "$authFile"
      echo "host = hotel-vpn.fw.reise.check24.de" >> "$authFile"
      echo "port = 443" >> "$authFile"
      echo "set-dns = 0" >> "$authFile"
      echo "pppd-use-peerdns = 0" >> "$authFile"

      sudo ${pkgs.openfortivpn}/bin/openfortivpn -c "$authFile"
    '')
  ];
}
