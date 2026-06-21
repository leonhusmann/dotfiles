{ config, lib, pkgs, ... }:

let
  secretServers = lib.filterAttrs (_: server: server.secretEnvironment != {}) config.my.mcp.servers;
  secretRoot = "${config.xdg.stateHome}/mcp";

  secretFile = serverName: envName: "${secretRoot}/${serverName}/${envName}";
  wrapperPath = serverName: "${secretRoot}/${serverName}/run";

  wrapperFile = serverName: server: pkgs.writeShellScript "mcp-${serverName}" ''
    set -o errexit

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (envName: _:
      ''export ${envName}="$(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg (secretFile serverName envName)})"''
    ) server.secretEnvironment)}

    exec ${lib.escapeShellArgs server.command}
  '';

  writeSecret = serverName: envName: ref: ''
    secret_file=${lib.escapeShellArg (secretFile serverName envName)}
    secret_tmp="$secret_file.tmp"
    secret_value="$(${pkgs._1password-cli}/bin/op read ${lib.escapeShellArg ref})"

    ${pkgs.coreutils}/bin/printf '%s' "$secret_value" > "$secret_tmp"
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod 0600 "$secret_tmp"
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/mv "$secret_tmp" "$secret_file"
  '';

  installServerSecrets = serverName: server: ''
    server_dir=${lib.escapeShellArg "${secretRoot}/${serverName}"}
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -d -m 0700 "$server_dir"

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (writeSecret serverName) server.secretEnvironment)}

    $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 0700 ${lib.escapeShellArg (toString (wrapperFile serverName server))} ${lib.escapeShellArg (wrapperPath serverName)}
  '';
in

{
  options.my.mcp.servers = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        transport = lib.mkOption {
          type = lib.types.enum [ "stdio" "http" ];
          default = "stdio";
          description = "MCP transport type.";
        };

        command = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Command and arguments for stdio servers.";
        };

        url = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "URL for remote servers.";
        };

        environment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {};
          description = "Non-secret environment variables.";
        };

        secretEnvironment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {};
          description = "Environment variables resolved from 1Password (op:// refs).";
        };

        oauth = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this remote server uses OAuth.";
        };
      };
    });
    default = {};
    description = "MCP server definitions for AI tools.";
  };

  config = lib.mkIf (secretServers != {}) {
    home.packages = [ pkgs._1password-cli ];

    home.activation.mcpSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList installServerSecrets secretServers)}
    '';
  };
}
