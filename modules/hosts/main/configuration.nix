{ self, inputs, ... }: {

  flake.nixosModules.mainConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.mainHardware
      self.nixosModules.niri
      self.nixosModules.packages
      self.nixosModules.shell
      self.nixosModules.libvirt
      self.nixosModules.hosts
    ];

    system.stateVersion = "25.11";

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # Noctalia pre-built binaries (avoids local compilation of Quickshell)
      extra-substituters      = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    time.timeZone = "Europe/Paris";

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS        = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT    = "fr_FR.UTF-8";
      LC_MONETARY       = "fr_FR.UTF-8";
      LC_NAME           = "fr_FR.UTF-8";
      LC_NUMERIC        = "fr_FR.UTF-8";
      LC_PAPER          = "fr_FR.UTF-8";
      LC_TELEPHONE      = "fr_FR.UTF-8";
      LC_TIME           = "fr_FR.UTF-8";
    };

    console.keyMap = "fr";
    services.xserver.xkb = {
      layout  = "fr";
      variant = "azerty";
    };

    users.users.log_s = {
      isNormalUser = true;
      extraGroups  = [ "wheel" "docker" "video" "networkmanager" "wireshark" "libvirtd" ];
    };

    security.sudo.wheelNeedsPassword = true;

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
        user    = "greeter";
      };
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin        = "no";
      };
    };

    # Disabled to allow inbound reverse-shell callbacks on arbitrary ports.
    networking.firewall.enable = false;

    # ── Noctalia requirements ─────────────────────────────────────────────
    networking.networkmanager.enable   = true;
    hardware.bluetooth.enable          = true;
    hardware.bluetooth.powerOnBoot     = true;
    services.blueman.enable            = true;
    services.power-profiles-daemon.enable = true;

    # dconf is needed for GTK/GSettings sync (noctalia syncGsettings)
    programs.dconf.enable = true;

    # enable nix-ld to run non nixos binaries
    programs.nix-ld.enable = true;
    programs.wireshark.enable = true;

    # Calendar widget in noctalia control center
    services.gnome.evolution-data-server.enable = true;

    # ── Qt theming ────────────────────────────────────────────────────────
    environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

    # ── NVIDIA + Wayland ──────────────────────────────────────────────────
    # niri (smithay-based) needs GBM from the NVIDIA stack, not Mesa's stub.
    environment.sessionVariables = {
      GBM_BACKEND          = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME    = "nvidia";
      NVD_BACKEND          = "direct"; # nvdec VA-API backend
    };

    # ── Podman container registries ───────────────────────────────────────
    virtualisation.containers.registries.search = [ "docker.io" ];

    # ── Font defaults ─────────────────────────────────────────────────────
    fonts.fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" "monospace" ];
    };
  };

}
