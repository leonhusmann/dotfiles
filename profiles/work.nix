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

  home.file.".cursor/mcp.json".text = builtins.toJSON {
    mcpServers = {
      bitbucket = {
        command = "bitbucket-mcp-server";
      };
      atlassian-mcp-server = {
        url = "https://mcp.atlassian.com/v1/mcp/authv2";
      };
    };
  };

  # Register MCP servers in Claude Code (~/.claude.json is a live file, so use
  # activation scripts instead of home.file to avoid clobbering Claude's state).
  home.activation.claudeMcpServers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.claude-code}/bin/claude mcp add \
      --transport http atlassian-mcp-server https://mcp.atlassian.com/v1/mcp/authv2 \
      -s user 2>/dev/null || true
    $DRY_RUN_CMD ${pkgs.claude-code}/bin/claude mcp add \
      bitbucket bitbucket-mcp-server \
      -s user 2>/dev/null || true
  '';

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
    (pkgs.writeShellScriptBin "bitbucket-mcp-server" ''
      export BITBUCKET_URL="https://api.bitbucket.org/2.0"
      export BITBUCKET_WORKSPACE="check24"
      export BITBUCKET_USERNAME="leon.husmann@check24.de"
      export BITBUCKET_PASSWORD="$(op read "op://Employee/nu5j7h3woz27twdzjhlcjnfzuu/password")"
      exec ${pkgs.nodejs}/bin/npx -y bitbucket-mcp@latest
    '')
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
