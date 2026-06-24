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
    lsp = {
      gopls = {
        command = [ "${pkgs.gopls}/bin/gopls" ];
        extensions = [ ".go" ];
      };

      typescript = {
        command = [
          "${pkgs.typescript-language-server}/bin/typescript-language-server"
          "--stdio"
        ];
        extensions = [ ".ts" ".tsx" ".js" ".jsx" ".mjs" ".cjs" ".mts" ".cts" ];
      };

      bash = {
        command = [ "${pkgs.bash-language-server}/bin/bash-language-server" "start" ];
        extensions = [ ".sh" ".bash" ".zsh" ".bashrc" ".bash_profile" ];
      };

      dockerfile = {
        command = [ "${pkgs.dockerfile-language-server}/bin/docker-langserver" "--stdio" ];
        extensions = [ ".dockerfile" ];
      };

      yaml = {
        command = [ "${pkgs.yaml-language-server}/bin/yaml-language-server" "--stdio" ];
        extensions = [ ".yaml" ".yml" ".sls" ];
      };

      markdown = {
        command = [ "${pkgs.marksman}/bin/marksman" "server" ];
        extensions = [ ".md" ".markdown" ];
      };

      sql = {
        command = [ "${pkgs.sqls}/bin/sqls" ];
        extensions = [ ".sql" ];
      };

      html = {
        command = [ "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server" "--stdio" ];
        extensions = [ ".html" ".htm" ".tmpl" ".gohtml" ];
      };

      groovy = {
        command = [ "${pkgs.groovy-language-server}/bin/groovy-language-server" ];
        extensions = [ ".groovy" ".gvy" ".Jenkinsfile" ];
      };

      jinja = {
        command = [ "${pkgs.jinja-lsp}/bin/jinja-lsp" ];
        extensions = [ ".j2" ".jinja" ".jinja2" ];
      };
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
