{
  description = "Leon's Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    antigravity-nix.url = "github:jacopone/antigravity-nix";
  };

  outputs = { nixpkgs, home-manager, catppuccin, antigravity-nix, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."macbook" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit catppuccin antigravity-nix;
          theme = "dark"; # Central theme selector: "light" or "dark"
        };
        modules = [
          catppuccin.homeModules.catppuccin
          ./hosts/macbook/default.nix
        ];
      };
    };
}
