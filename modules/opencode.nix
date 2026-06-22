{ config, lib, pkgs, ... }:

let
  mcpServers = config.my.mcp.servers;
  withoutNulls = attrs:
    lib.filterAttrs (_: v: v != null && v != {} && v != []) attrs;

  wrapperPath = serverName: "${config.xdg.stateHome}/mcp/${serverName}/run";

  renderMcpServer = name: server:
    let
      hasSecrets = server.secretEnvironment != {};
      base = if server.transport == "stdio" then {
        type = "local";
        command = if hasSecrets then [ (wrapperPath name) ] else server.command;
        enabled = true;
        environment = server.environment;
      } else {
        type = "remote";
        url = server.url;
        enabled = true;
        oauth = if server.oauth then {} else null;
      };
    in
    withoutNulls base;

  opencodeConfig = withoutNulls {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [
      "opencode-with-claude"
      "@rama_nigg/open-cursor@latest"
    ];
    provider.anthropic.options = {
      baseURL = "http://127.0.0.1:3456";
      apiKey = "dummy";
    };
    provider."cursor-acp" = {
      name = "Cursor ACP";
      npm = "@ai-sdk/openai-compatible";
      options.baseURL = "http://127.0.0.1:32124/v1";
      models."composer-2.5".name = "Composer 2.5";
    };
    mcp = lib.mapAttrs renderMcpServer mcpServers;
  };
in
{
  imports = [ ./mcp.nix ];

  config = {
    home.packages = [ pkgs.opencode ];

    home.file.".config/opencode/opencode.json" = {
      text = builtins.toJSON opencodeConfig;
      force = true;
    };
  };
}
