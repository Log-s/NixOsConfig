{ inputs, pkgs, ... }: {
  programs.noctalia = {
    enable = true;
    # Pin to the same store path niri uses for spawn-at-startup so there
    # is only one noctalia derivation in the closure.
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # v5 is configured with a single TOML file (v4's settings.json + plugins.json
    # are gone). Passing the path directly keeps the comments in that file; the
    # module still runs `noctalia config validate` on it at build time.
    settings = ../../modules/features/noctalia/config.toml;
  };

  # Deploy wallpaper into the directory noctalia watches.
  # home.file creates a read-only symlink from the nix store, which is fine
  # for display purposes. Adding images here is the only way to add wallpapers
  # declaratively; noctalia picks from the directory at random (only one image
  # means it always uses this one).
  home.file."Pictures/Wallpapers/rafale.png".source = ../../assets/wallpapers/rafale.png;
}
