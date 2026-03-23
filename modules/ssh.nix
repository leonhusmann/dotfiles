{ config, lib, ... }:

{
  options.my.ssh = {
    extraHosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
      description = "Extra SSH host configurations merged into ssh_config";
    };
  };

  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          IgnoreUnknown = "UseKeychain";
          UseKeychain = "yes";
        };
      } // config.my.ssh.extraHosts;
    };
  };
}
