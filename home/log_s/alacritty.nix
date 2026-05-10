{ ... }: {
  # Colors are intentionally omitted here: noctalia's alacritty template
  # generates and writes them to ~/.config/alacritty/ at runtime whenever
  # the color scheme changes.
  programs.alacritty = {
    enable = true;
    settings.font = {
      normal  = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
      bold    = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
      italic  = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
      size = 12.0;
    };
  };
}
