{ antigravity-nix, pkgs, ... }:

{
  home.packages = [
    antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
  ];
}
