{ config, lib, pkgs, ... }:

let
  agents = config.my.agents;
  mcpServers = config.my.mcp.servers;
  secretFile = serverName: envName: "${config.xdg.stateHome}/mcp/${serverName}/${envName}";

  withoutNulls = attrs:
    lib.filterAttrs (_: v: v != null && v != {} && v != []) attrs;

  renderFrontmatter = attrs:
    let
      nonNull = withoutNulls attrs;
      lines = lib.mapAttrsToList (k: v: "${k}: ${builtins.toJSON v}") nonNull;
    in
    "---\n" + lib.concatStringsSep "\n" lines + "\n---\n\n";

  renderMcpEnvironment = serverName: server:
    server.environment // lib.mapAttrs (envName: _: "{file:${secretFile serverName envName}}") server.secretEnvironment;

  renderMcpServer = name: server:
    let
      base = if server.transport == "stdio" then {
        type = "local";
        command = server.command;
        enabled = true;
        environment = renderMcpEnvironment name server;
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
