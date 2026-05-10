{ self, inputs, ... }: {
  flake.nixosModules.packages = { pkgs, lib, ... }: {
    nixpkgs.config.allowUnfree = true;

    # Apply NUR as an overlay so pkgs.nur.repos.* uses the same nixpkgs
    # instance (and therefore the same allowUnfree = true) as everything else.
    nixpkgs.overlays = [ inputs.nur.overlays.default ];

    environment.systemPackages = with pkgs; [
      # Core tools
      gnupg curl wget zip unzip fontconfig file xxd jq
      imagemagick wl-clipboard wdisplays

      # Shells & terminal (alacritty installed by home-manager)
      zsh

      # Editors
      vim neovim

      # Languages & runtimes
      go ruby
      rustup rust-analyzer
      python3 python313Packages.python-lsp-server python313Packages.ruff
      gcc gnumake libclang
      nodejs typescript-language-server vue-language-server

      # Productivity & search
      fzf ripgrep fd luarocks sqlite claude-code

      # Security / pentesting
      tcpdump sqlmap hashcat python3Packages.impacket mitmproxy proxychains-ng
      nmap burpsuite bruno semgrep wpscan binwalk wireshark
      caido-cli caido-desktop ffuf

      # Firefox color-scheme integration
      pywalfox-native

      # Browser & apps
      vesktop signal-desktop

      # Wayland desktop
      brightnessctl cliphist wlsunset
      xdg-desktop-portal-gtk
      nautilus
      grim slurp

      # GTK / Qt theming (noctalia integration)
      adw-gtk3
      adwaita-icon-theme

      # Misc
      lsd
      podman-compose
      linux-wifi-hotspot
      pipx
      zenity
    ];

    # Container runtimes
    virtualisation.docker.enable = true;
    virtualisation.podman = {
      enable       = true;
      dockerCompat = false;
    };

    # Hardware power management (also required by noctalia)
    services.upower.enable = true;

    # XDG portal (file pickers, screenshots, etc.)
    xdg.portal = {
      enable       = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    # JetBrainsMono Nerd Font
    fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };
}
