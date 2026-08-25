{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # Spicetify-nix patches Spotify at build time (nix store is read-only so
  # runtime patching via `spicetify apply` is not possible on NixOS).
  #
  # This means Spotify does NOT follow the wallpaper palette: the colours end up
  # in xpui/colors.css inside the store path, and Spotify reads them from there.
  # Noctalia's spicetify community template still writes
  # ~/.config/spicetify/Themes/Comfy/color.ini, but nothing reads that file and
  # its post-hook (`spicetify apply`) has no spicetify binary on PATH to run.
  # To change Spotify's palette, edit colorScheme below and rebuild.
  programs.spicetify = {
    enable      = true;
    theme       = spicePkgs.themes.comfy;
    colorScheme = "catppuccin-mocha";  # valid Comfy schemes: catppuccin-{latte,frappe,macchiato,mocha}, rose-pine{,-moon,-dawn}, Nord, Velvet, wal16, ...
  };
}
