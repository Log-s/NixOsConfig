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
    # mkdocs-static-i18n isn't in nixpkgs; the homelab wiki needs it for its
    # FR/EN bilingual setup, so package it from PyPI directly.
    mkdocs-static-i18n = pkgs.python313Packages.buildPythonPackage {
      pname   = "mkdocs-static-i18n";
      version = "1.3.1";
      format  = "wheel";
      src = pkgs.fetchurl {
        url    = "https://files.pythonhosted.org/packages/6a/0b/43ff4afb6b438d47718b1959a22075ed95d8460d8c47381878b37a40de63/mkdocs_static_i18n-1.3.1-py3-none-any.whl";
        sha256 = "sha256-QDbiR5WhUMnE1LAB7SSkOuwBM192GI2+Wl2PtKJ+umU=";
      };
      propagatedBuildInputs = [ pkgs.python313Packages.mkdocs ];
    };
    # mkdocs and its plugins must share one Python environment so the
    # mkdocs binary can actually import them — as separate top-level
    # packages each gets its own isolated site-packages.
    mkdocs-with-material = pkgs.python313.withPackages (ps: [
      ps.mkdocs
      ps.mkdocs-material
      mkdocs-static-i18n
    ]);
    # JDKs available side by side. The one in programs.java below is the
    # default `java` on PATH; every version here also gets versioned binaries
    # (java21/java24/...) and an entry in the `use-java` switcher, both
    # generated from this attrset — adding a version is a one-line change.
    # 24 is EOL and gone from nixpkgs-unstable, hence the separate flake pin.
    jdks = {
      "21" = pkgs.temurin-bin-21;
      "24" = inputs.nixpkgs-jdk24.legacyPackages.${pkgs.stdenv.hostPlatform.system}.temurin-bin-24;
      "25" = pkgs.temurin-bin-25;
    };
    # Two JDKs in systemPackages would collide (both own bin/java, bin/javac,
    # ...), so the non-default ones are exposed only under versioned names.
    # The tools resolve their own JDK home through /proc/self/exe, so a plain
    # symlink is enough — no wrapper script needed.
    jdk-alts = pkgs.runCommand "jdk-alts" { } (''
      mkdir -p $out/bin
    '' + lib.concatStrings (lib.mapAttrsToList (ver: jdk: ''
      for b in java javac jar jshell javap keytool jcmd; do
        if [ -e ${jdk}/bin/$b ]; then ln -s ${jdk}/bin/$b $out/bin/''${b}${ver}; fi
      done
    '') jdks));

  in {
    nixpkgs.config.allowUnfree = true;

    # Apply NUR as an overlay so pkgs.nur.repos.* uses the same nixpkgs
    # instance (and therefore the same allowUnfree = true) as everything else.
    nixpkgs.overlays = [ inputs.nur.overlays.default ];

    environment.systemPackages = with pkgs; [
      # Core tools
      gnupg curl wget zip unzip fontconfig file xxd jq tree
      imagemagick wl-clipboard wdisplays openvpn wl-mirror
      glib glibc
      
      # Shells & terminal (alacritty installed by home-manager)
      zsh

      # Editors
      vim neovim

      # Languages & runtimes
      # (the default JDK comes from programs.java below, so it isn't listed
      # here; jdk-alts adds the versioned java21/java24/java25 binaries)
      jdk-alts
      go ruby
      rustup rust-analyzer
      python3 python313Packages.ruff basedpyright
      mkdocs-with-material
      gcc gnumake libclang
      nodejs typescript-language-server vue-language-server

      # Productivity & search
      fzf ripgrep fd luarocks sqlite claude-code

      # Security / pentesting
      tcpdump sqlmap hashcat john python3Packages.impacket mitmproxy proxychains-ng
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
      # chromium is used headlessly by httpx (-system-chrome) for screenshots;
      # the go-rod tarball it would otherwise download is not linked for NixOS.
      chromium

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
      openssl
    ];

    # Java: Temurin (prebuilt OpenJDK) rather than pkgs.jdk. programs.java
    # installs the package *and* exports JAVA_HOME via the jdk setup-hook,
    # which pkgs.jdk in systemPackages alone would not do.
    # binfmt registers handlers so `./foo.jar` and `./Foo.class` are directly
    # executable — handy for jar-shipped tools like PwnFox.jar or ysoserial.
    programs.java = {
      enable  = true;
      package = jdks."21";   # the default `java`; change to another key of jdks
      binfmt  = true;
    };

    # Per-shell JDK switcher: `use-java 24` points JAVA_HOME at that JDK and
    # puts its bin first on PATH, so build tools (maven, gradle) follow along
    # for the rest of the session. Lives here rather than in the home-manager
    # zsh config so it stays next to the jdks attrset it is generated from —
    # NixOS writes this to /etc/zshrc, which zsh sources before ~/.zshrc.
    programs.zsh.interactiveShellInit = ''
      use-java() {
        local root
        case "$1" in
        ${lib.concatStringsSep "\n  "
            (lib.mapAttrsToList (ver: jdk: "${ver}) root=${jdk} ;;") jdks)}
        *)
          echo "usage: use-java ${lib.concatStringsSep "|" (builtins.attrNames jdks)}" >&2
          return 1
          ;;
        esac
        # drop a previously selected JDK so repeated calls don't stack up PATH
        # (the path array is zsh's tied view of PATH, so this rewrites both)
        [ -n "$JAVA_HOME" ] && path=("''${(@)path:#$JAVA_HOME/bin}")
        export JAVA_HOME="$root"
        path=("$JAVA_HOME/bin" $path)
        java -version
      }
      (( $+functions[compdef] )) && \
        compdef '_values "jdk version" ${lib.concatStringsSep " " (builtins.attrNames jdks)}' use-java
    '';

    # Swing/AWT ships with font anti-aliasing off, which is why Java GUIs
    # (burpsuite here — its nixpkgs wrapper is a plain `java -jar`, it sets no
    # rendering flags of its own) look chunky. Read by every HotSpot JVM, so it
    # applies to jars run outside the JDK above too. Trade-off: the VM prints
    # "Picked up _JAVA_OPTIONS: ..." on stderr at every launch — switch to
    # `on` (grey-scale AA) if `lcd` subpixel rendering fringes on a display.
    environment.sessionVariables._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true";

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
