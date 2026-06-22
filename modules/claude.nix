{ config, lib, pkgs, ... }:

let
  mcpServers = config.my.mcp.servers;
  secretWrapper = serverName: "${config.xdg.stateHome}/mcp/${serverName}/run";

  commandHead = command: builtins.elemAt command 0;
  commandTail = command: lib.drop 1 command;

  withoutNulls = attrs:
    lib.filterAttrs (_: v: v != null && v != {} && v != []) attrs;

  renderMcpServer = name: server:
    let
      hasSecrets = server.secretEnvironment != {};
      base = if server.transport == "stdio" then {
        type = "stdio";
        command = if hasSecrets then secretWrapper name else commandHead server.command;
        args = if hasSecrets then [] else commandTail server.command;
        env = server.environment;
      } else {
        type = server.transport;
        url = server.url;
      };
    in
    withoutNulls base;

  mcpConfigFile = pkgs.writeText "claude-mcp-servers.json" (builtins.toJSON (lib.mapAttrs renderMcpServer mcpServers));
in
{
  imports = [ ./mcp.nix ];

  config = {
    home.activation.claudeMcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      claude_json="${config.home.homeDirectory}/.claude.json"
      mcp_tmp="$(${pkgs.coreutils}/bin/mktemp)"
      claude_tmp="$(${pkgs.coreutils}/bin/mktemp)"
      trap '${pkgs.coreutils}/bin/rm -f "$mcp_tmp" "$claude_tmp"' EXIT

      $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 0600 ${lib.escapeShellArg (toString mcpConfigFile)} "$mcp_tmp"

      if [ ! -e "$claude_json" ]; then
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 0600 ${pkgs.writeText "empty-claude.json" "{}"} "$claude_json"
      fi

      ${pkgs.jq}/bin/jq --slurpfile mcp "$mcp_tmp" '.mcpServers = $mcp[0]' "$claude_json" > "$claude_tmp"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/mv "$claude_tmp" "$claude_json"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod 0600 "$claude_json"
    '';
  };
}
