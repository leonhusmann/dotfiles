{ theme, ... }:

{
  imports = [
    (if theme == "light" then ./light.nix else ./dark.nix)
  ];

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
}
