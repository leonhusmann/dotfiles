# Agent Instructions: Nix/Home Manager Verification

This repository uses a modular Nix Flake structure. Agents must follow this protocol to discover valid options and verify configuration integrity. Agents are restricted to **evaluation and verification only**; do not execute `switch` or `apply` commands.

## 1. Discovery

### Find Option Schema
Inspect valid types, descriptions, and default values for Home Manager options. 

`nix eval .#homeConfigurations.macbook.options.<OPTION_PATH> --json | jq`

*Example:* `nix eval .#homeConfigurations.macbook.options.programs.git --json | jq`

### Search Packages
Find the correct attribute names in the `nixpkgs` registry.

`nix search nixpkgs <SEARCH_TERM>`

## 2. Verification Pipeline

Agents must execute this sequence after any file modification to ensure the configuration is hermetically valid and builds successfully.

### Step 1: Register Intent
Nix Flakes ignore files not tracked by Git. This command makes new/moved files visible to the Nix evaluator without creating a commit.

`git add -N .`

### Step 2: Flake Check
Validate the `flake.nix` syntax and ensure all input references are resolved.

`nix flake check`

### Step 3: Dry-Run Build
This is the final verification. It performs a full evaluation of the logic, types, and dependencies. If this command exits with code 0, the configuration is guaranteed to be valid.

`home-manager build --flake .#macbook`

### Step 4: Cleanup
If the build succeeds, a `result` symlink is created in the root. Remove it to maintain a clean workspace.

`rm result`

## 3. Debugging
If a build fails, use the trace flag to locate the specific line in the `.nix` source causing the evaluation error.

`home-manager build --flake .#macbook --show-trace`
