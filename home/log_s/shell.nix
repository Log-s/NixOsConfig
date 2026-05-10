{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    initContent = ''
      source <(${pkgs.fzf}/bin/fzf --zsh)

      alias ls='${pkgs.lsd}/bin/lsd'
      alias la='${pkgs.lsd}/bin/lsd -A'
      alias ll='${pkgs.lsd}/bin/lsd -al'
      alias tmp="cd ~/Downloads"

      export EDITOR=vim
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
