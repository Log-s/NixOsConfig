{ self, inputs, ... }: {
  flake.nixosModules.packages = { pkgs, lib, ... }:
  let
    # PwnFox Burp/Caido extension — fetched from the upstream release so
    # it can be loaded from /run/current-system/sw/share/pwnfox/PwnFox.jar.
    pwnfox-jar = pkgs.fetchurl {
      url    = "https://github.com/yeswehack/PwnFox/releases/download/v1.0.3/PwnFox.jar";
      sha256 = "sha256-7drvaK/5L9afUHSXgD+G3auXJ1FYJXMiSO1ELaCNlx4=";
    };
    pwnfox = pkgs.runCommand "pwnfox-1.0.3" { } ''
      mkdir -p $out/share/pwnfox
      cp ${pwnfox-jar} $out/share/pwnfox/PwnFox.jar
    '';
  in {
    nixpkgs.config.allowUnfree = true;

    # Apply NUR as an overlay so pkgs.nur.repos.* uses the same nixpkgs
    # instance (and therefore the same allowUnfree = true) as everything else.
    nixpkgs.overlays = [ inputs.nur.overlays.default ];

    environment.systemPackages = with pkgs; [
      # Core tools
      gnupg curl wget zip unzip fontconfig file xxd jq tree
      imagemagick wl-clipboard wdisplays openvpn wl-mirror

      # Shells & terminal (alacritty installed by home-manager)
      zsh

      # Editors
      vim neovim

      # Languages & runtimes
      go ruby
      rustup rust-analyzer
      python3 python313Packages.ruff basedpyright
      gcc gnumake libclang
      nodejs typescript-language-server vue-language-server

      # Productivity & search
      fzf ripgrep fd luarocks sqlite claude-code

      # Security / pentesting
      tcpdump sqlmap hashcat python3Packages.impacket mitmproxy proxychains-ng
      nmap burpsuite bruno semgrep wpscan binwalk wireshark
      caido-cli caido-desktop ffuf feroxbuster rlwrap ldeep netexec responder
      # GNU netcat (supports -e for reverse shells). hiPrio so its `nc`
      # binary wins over netcat-openbsd, which other packages pull in.
      (lib.hiPrio netcat-gnu)
      pwnfox

      # Firefox color-scheme integration
      pywalfox-native

      # Browser & apps
      vesktop signal-desktop obsidian

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
