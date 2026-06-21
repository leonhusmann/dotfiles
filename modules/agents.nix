{ lib, ... }:

{
  options.my.agents = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        description = lib.mkOption {
          type = lib.types.str;
          description = "Agent routing description.";
        };

        prompt = lib.mkOption {
          type = lib.types.str;
          description = "Agent prompt text.";
        };

        readOnly = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Restrict to read-only operations where supported.";
        };
      };
    });
    default = {};
    description = "Agent definitions for AI tools.";
  };
}
