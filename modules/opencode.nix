{ config, lib, pkgs, ... }:

let
  agents = config.my.agents;
  mcpServers = config.my.mcp.servers;
  withoutNulls = attrs:
    lib.filterAttrs (_: v: v != null && v != {} && v != []) attrs;

  renderFrontmatter = attrs:
    let
      nonNull = withoutNulls attrs;
      lines = lib.mapAttrsToList (k: v: "${k}: ${builtins.toJSON v}") nonNull;
    in
    "---\n" + lib.concatStringsSep "\n" lines + "\n---\n\n";

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

  renderAgent = name: agent:
    let
      baseFrontmatter = {
        inherit (agent) description;
        mode = "subagent";
        permission = if agent.readOnly then { edit = "deny"; } else null;
      };
      frontmatter = renderFrontmatter baseFrontmatter;
    in
    frontmatter + agent.prompt;
in
{
  imports = [ ./agents.nix ./mcp.nix ];

  config = {
    home.packages = [ pkgs.opencode ];

    home.file =
      {
        ".config/opencode/opencode.json" = {
          text = builtins.toJSON opencodeConfig;
          force = true;
        };
      }
      // lib.mapAttrs' (name: agent: lib.nameValuePair ".config/opencode/agents/${name}.md" { text = renderAgent name agent; force = true; }) agents;
  };
}
