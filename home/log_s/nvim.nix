{ ... }: {
  # Deploy nvim config files as nix-store symlinks.
  # The directory ~/.config/nvim/ itself stays writable so lazy.nvim can
  # manage lazy-lock.json at runtime without hitting the read-only store.
  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua".source     = ./nvim/lua;
}
