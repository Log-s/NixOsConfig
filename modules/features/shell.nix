{ self, inputs, ... }: {
  flake.nixosModules.shell = { pkgs, ... }: {
    # Enable zsh system-wide so it appears in /etc/shells and is selectable as login shell.
    # All user-level zsh config (oh-my-zsh, aliases, plugins) lives in home/log_s/shell.nix.
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
