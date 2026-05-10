{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # Spicetify-nix patches Spotify at build time (nix store is read-only so
  # runtime patching via `spicetify apply` is not possible on NixOS).
  # Noctalia's spicetify template updates the color variables in
  # ~/.config/spicetify/, but the theme CSS itself is baked in here.
  # Change colorScheme and rebuild to switch palettes.
  programs.spicetify = {
    enable      = true;
    theme       = spicePkgs.themes.comfy;
    colorScheme = "catppuccin-mocha";  # valid Comfy schemes: catppuccin-{latte,frappe,macchiato,mocha}, rose-pine{,-moon,-dawn}, Nord, Velvet, wal16, ...
  };
}
