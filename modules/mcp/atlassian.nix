{ ... }:

{
  imports = [ ../mcp.nix ];

  my.mcp.servers.atlassian-mcp-server = {
    transport = "http";
    url = "https://mcp.atlassian.com/v1/mcp/authv2";
    oauth = true;
  };
}
