{ inputs, pkgs, ... }: {
  programs.noctalia-shell = {
    enable = true;
    # Pin to the same store path niri uses for spawn-at-startup so there
    # is only one noctalia derivation in the closure.
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = builtins.fromJSON (builtins.readFile ../../modules/features/noctalia/settings.json);
    plugins  = builtins.fromJSON (builtins.readFile ../../modules/features/noctalia/plugins.json);
  };

  # Deploy wallpaper into the directory noctalia watches.
  # home.file creates a read-only symlink from the nix store, which is fine
  # for display purposes. Adding images here is the only way to add wallpapers
  # declaratively; noctalia picks from the directory at random (only one image
  # means it always uses this one).
  home.file."Pictures/Wallpapers/rafale.png".source = ../../assets/wallpapers/rafale.png;
}
