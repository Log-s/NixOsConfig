{ self, inputs, ... }: {
  flake.nixosModules.hosts = { ... }: {
    networking.hosts = {
      "127.0.0.1" = [ "localhost" "l0calh0st" ];
      "::1"       = [ "localhost" ];
      "127.0.0.2" = [ "nixos" ];
    };
  };
}
