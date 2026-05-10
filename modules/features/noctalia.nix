{ self, inputs, ... }: {
  # Expose the noctalia package so niri's spawn-at-startup can reference it
  # by its exact store path. Configuration is handled by programs.noctalia-shell
  # in home/log_s/noctalia.nix via the noctalia homeModules.
  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
