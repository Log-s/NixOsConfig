{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # JDK 24 is EOL and was removed from nixos-unstable (2025-10-04), so it is
    # pulled from the last release branch that still packages it. Deliberately
    # not `follows`-ing nixpkgs — the whole point of this input is the old pin.
    nixpkgs-jdk24.url = "github:nixos/nixpkgs/nixos-25.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # v5 lives in a new repo (noctalia-shell was v4). nixpkgs is deliberately
    # NOT followed here: the noctalia.cachix.org substituter only has binaries
    # for the upstream input, and overriding nixpkgs changes the derivation
    # hash, which would force a local build of the whole C++/GL shell.
    noctalia.url = "github:noctalia-dev/noctalia";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
