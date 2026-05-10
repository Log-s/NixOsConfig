# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Key Commands

```bash
# Rebuild and switch (run from ~/NixOsConfig on the target machine)
sudo nixos-rebuild switch --flake .#main

# Build without switching (check for errors)
sudo nixos-rebuild build --flake .#main

# Evaluate a specific package (faster iteration on niri/noctalia)
nix build .#myNiri
nix build .#myNoctalia

# Update flake inputs
nix flake update

# Show full error trace
sudo nixos-rebuild switch --flake .#main --show-trace
```

## Architecture

### Module loading

`flake.nix` delegates everything to `flake-parts` and uses `import-tree` to auto-import **every `.nix` file under `modules/`** as a flake-parts module. There is no manual imports list in `flake.nix` — adding a file to `modules/` is enough for it to be picked up.

Each file in `modules/` must be a valid flake-parts module (top-level function receiving `{ self, inputs, ... }`). They expose outputs via `flake.nixosModules.*`, `flake.nixosConfigurations.*`, or `perSystem`.

### Two-layer structure

```
modules/          # flake-parts modules — system-level NixOS config
home/log_s/       # home-manager modules — user-level dotfiles
```

`home/` is outside `modules/` intentionally — import-tree would otherwise try to load home-manager modules as flake-parts modules, which would fail. The home config is wired in explicitly from `modules/hosts/main/default.nix`.

### How a feature gets activated

1. A feature file (e.g. `modules/features/packages.nix`) defines `flake.nixosModules.packages = { pkgs, ... }: { ... }`.
2. `modules/hosts/main/configuration.nix` lists it in `imports = [ self.nixosModules.packages ... ]`.
3. `modules/hosts/main/default.nix` builds the final `nixosSystem` and wires in home-manager.

### niri + noctalia (wrapper-modules pattern)

Both are built via `inputs.wrapper-modules.wrappers.<name>.wrap { inherit pkgs; settings = ...; }` in `perSystem`, producing `packages.myNiri` and `packages.myNoctalia`. The NixOS module (`programs.niri.package`) then points at the custom-built package.

niri settings are expressed as a Nix attrset in `modules/features/niri.nix` — wrapper-modules converts them to KDL. **KDL attributes** (inline `key=value` on a node line) cannot be expressed this way; only child nodes work. This is why `allow-when-locked` on media keys is currently omitted.

The generated niri config.kdl lives in the Nix store. An activation script in `modules/features/niri.nix` symlinks it to `~/.config/niri/config.kdl` so noctalia's keybind-cheatsheet plugin can read it.

### home-manager

Enabled as a NixOS module (`inputs.home-manager.nixosModules.home-manager`) with `useGlobalPkgs = true` and `useUserPackages = true`. The user config at `home/log_s/default.nix` imports per-tool files:

| File | Manages |
|------|---------|
| `shell.nix` | zsh, oh-my-zsh, fzf, lsd aliases |
| `alacritty.nix` | Noctalia color scheme, JetBrainsMono font |
| `tmux.nix` | tmux with vi mode, Ctrl+S prefix, wl-clipboard |
| `noctalia.nix` | Deploys `settings.json` and `plugins.json` via `home.file` |

Noctalia config JSON files live in `modules/features/noctalia/` and are referenced by path from both the wrapper-modules build and the home.file declarations.

### Known limitations / TODO

See `TODO.md` for the full list. Key items:
- `allow-when-locked` on media keys is not supported by wrapper-modules KDL rendering
- Wireshark is commented out due to a hash mismatch in the current nixpkgs pin
- Neovim config not yet ported (requires home-manager `programs.neovim` or nixvim)
- GTK theming, vesktop, spicetify not yet ported
