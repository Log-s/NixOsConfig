{ ... }: {
  # Colors are intentionally omitted here: noctalia's alacritty template
  # generates and writes them to ~/.config/alacritty/themes/noctalia.toml
  # at runtime whenever the color scheme changes. We bake the import line
  # in declaratively so alacritty picks the theme up immediately on boot —
  # noctalia's `sed -i` fallback can't modify the home-manager symlink.
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ "~/.config/alacritty/themes/noctalia.toml" ];
      font = {
        normal  = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold    = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        italic  = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        size = 12.0;
      };
    };
  };
}
