{ config, lib, ... }:

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
        url = server.url;
      };
    in
    withoutNulls base;

  cursorConfig = {
    mcpServers = lib.mapAttrs renderMcpServer mcpServers;
  };
in
{
  imports = [ ./mcp.nix ];

  config.home.file.".cursor/mcp.json" = {
    text = builtins.toJSON cursorConfig;
    force = true;
  };
}
