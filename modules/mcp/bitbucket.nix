{ pkgs, ... }:

{
  imports = [ ../mcp.nix ];

  my.mcp.servers.bitbucket = {
    transport = "stdio";
    command = [ "${pkgs.nodejs}/bin/npx" "-y" "bitbucket-mcp@latest" ];
    environment = {
      BITBUCKET_URL = "https://api.bitbucket.org/2.0";
      BITBUCKET_WORKSPACE = "check24";
      BITBUCKET_USERNAME = "leon.husmann@check24.de";
      BITBUCKET_ENABLE_DANGEROUS = "false";
    };
    secretEnvironment = {
      BITBUCKET_PASSWORD = "op://Employee/nu5j7h3woz27twdzjhlcjnfzuu/password";
    };
  };
}
