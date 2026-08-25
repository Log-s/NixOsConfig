{ ... }: {
  programs.helix = {
    enable = true;

    # Written at runtime by noctalia's built-in `helix` template
    # (~/.config/helix/themes/noctalia.toml), so it follows the wallpaper
    # palette instead of being pinned to a hand-written Dracula theme.
    settings.theme = "noctalia";
    settings.editor.line-number = "relative";

    languages.language-server.basedpyright = {
      command = "basedpyright-langserver";
      args = [ "--stdio" ];
    };

    languages.language-server.ruff = {
      command = "ruff";
      args = [ "server" ];
    };

    languages.language = [{
      name = "python";
      language-servers = [ "basedpyright" "ruff" ];
      formatter = { command = "ruff"; args = [ "format" "-" ]; };
      auto-format = true;
    }];
  };
}
