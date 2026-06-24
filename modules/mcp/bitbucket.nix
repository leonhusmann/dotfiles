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
    };
    secretEnvironment = {
      BITBUCKET_TOKEN = "op://Employee/c4hnroxib6gen6uzu35u7hm3g4/password";
    };
  };
}
