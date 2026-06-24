{ pkgs, ... }:

{
  imports = [ ../mcp.nix ];

  my.mcp.servers.bitbucket = {
    transport = "stdio";
    command = [ "${pkgs.nodejs}/bin/npx" "-y" "bitbucket-mcp@latest" ];
    environment = {
      BITBUCKET_URL = "https://api.bitbucket.org/2.0";
      BITBUCKET_WORKSPACE = "check24";
      BITBUCKET_ENABLE_DANGEROUS = "false";
      BITBUCKET_USERNAME = "leon.husmann@check24.de";
    };
    secretEnvironment = {
      BITBUCKET_PASSWORD = "op://Employee/yqb5lp4bof5c2lg7o6v4pn2due/password";
    };
  };
}
