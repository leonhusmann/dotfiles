{ lib, pkgs, ... }:

let
  threedots-cli = import ../packages/threedots-cli.nix { inherit pkgs; };
in
{
  imports = [
    ../modules/bash.nix
    ../modules/git.nix
    ../modules/starship.nix
    ../modules/vim.nix
    ../modules/ssh.nix
    ../modules/go.nix
    ../modules/neovim.nix
    ../modules/tmux.nix
    ../modules/antigravity.nix
    ../modules/kitty.nix
  ];

  my.git.userEmail = lib.mkDefault "git@leonhusmann.com";

  programs.fastfetch.enable = true;
  programs.htop.enable = true;
  programs.lazygit.enable = true;
  programs.firefox.enable = true;
  programs.obsidian.enable = true;

  home.packages = [
    pkgs.nodejs
    pkgs.proton-pass
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.zotero
    pkgs.spotify
    pkgs.opencode
    threedots-cli
  ];
}
