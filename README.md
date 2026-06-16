# Leon's personal dotfiles

Multi-machine, and multi-platform dotfiles managed with Nix Flakes and Home Manager.

## Repository Structure

*   `hosts/` - Machine-specific entry points (e.g., `macbook`)
*   `modules/` - Modular configuration components (shell, editor, tools)
*   `profiles/` - Logical configuration layers (`personal`, `work`)
*   `themes/` - Theme assets and styles (e.g., Catppuccin)

## Commands Reference

Run commands from the repository root.

### Verification (Dry-Run)
Ensure syntax validity and dry-run code evaluation before switching:
```bash
# Validate flake syntax and inputs
nix flake check

# Build Home Manager configuration locally (without applying)
home-manager build --flake .#macbook
```

### Deployment (Switching)
Apply the configuration to the active system:
```bash
# Apply Home Manager configuration
home-manager switch --flake .#macbook -b backup

# Apply NixOS configuration (system-wide)
sudo nixos-rebuild switch --flake .#<host>

# Apply macOS Nix-Darwin configuration (system-wide)
darwin-rebuild switch --flake .#<host>
```

### Maintenance
```bash
# Update all flake dependencies
nix flake update

# Clean up unused Nix store paths (Garbage Collection)
nix-collect-garbage -d
```
