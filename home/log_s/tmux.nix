{ pkgs, ... }:
let
  catppuccin-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version    = "unstable-2025-05-09";
    src = pkgs.fetchFromGitHub {
      owner  = "catppuccin";
      repo   = "tmux";
      rev    = "d2d25bd3393fe43f19eb4fff6cdd2bdf5578e622";
      sha256 = "sha256-3CJRQCgS8NAN7vOLBjNGiHbGXTIrIyY/FLmfZrXcEYc=";
    };
  };
in {
  programs.tmux = {
    enable    = true;
    mouse     = true;
    keyMode   = "vi";
    shortcut  = "s";
    terminal  = "tmux-256color";

    plugins = [
      {
        plugin      = catppuccin-tmux;
        extraConfig = ''
          set -g @catppuccin_flavor "frappe"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_current_text " #{window_name}"
          set -g @catppuccin_window_text " #{window_name}"
        '';
      }
    ];

    extraConfig = ''
      set-option -g status-position top

      set -g status-right ""
      set -g status-left ""

      # Prevent the shell from overriding window names via terminal escape codes;
      # window names now only change via automatic-rename (current process) or manual Ctrl+S ,.
      set -g allow-rename off

      unbind r
      bind r source-file ~/.tmux.conf

      bind -n M-Left  select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up    select-pane -U
      bind -n M-Down  select-pane -D

      bind j split-window -v -c "#{pane_current_path}"
      bind h split-window -h -c "#{pane_current_path}"
      bind x kill-pane

      unbind-key -T copy-mode-vi v
      bind Enter copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      bind P paste-buffer
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
    '';
  };
}
