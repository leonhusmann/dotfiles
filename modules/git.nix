{ config, lib, pkgs, ... }:

{
  options.my.git = {
    userName = lib.mkOption {
      type = lib.types.str;
      default = "Leon Husmann";
      description = "Git user name";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "git@leonhusmann.com";
      description = "Git user email";
    };
  };

  config = {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = config.my.git.userName;
          email = config.my.git.userEmail;
        };
        core = {
          editor = "vim";
        };
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
      };

      ignores = [
        ".DS_Store"
        ".idea/"
        ".ai/"
        ".agents"
        ".vscode/"
        ".opencode"
      ];
    };
  };
}
