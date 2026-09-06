{ inputs, ... }: {
  imports = [
    inputs.noctalia.homeModules.default
    inputs.spicetify-nix.homeManagerModules.default
    ./shell.nix
    ./alacritty.nix
    ./tmux.nix
    ./noctalia.nix
    ./gtk.nix
    ./spicetify.nix
    ./tools.nix
    ./claude.nix
    ./firefox.nix
    ./vscodium.nix
    ./helix.nix
    ./nvim.nix
    ./xdg.nix
    ./git.nix
    ./kanshi.nix
  ];

  home.username    = "log_s";
  home.homeDirectory = "/home/log_s";
  home.stateVersion  = "25.11";
}
