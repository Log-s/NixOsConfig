{ pkgs, ... }: {
  # adw-gtk3 is the GTK theme noctalia uses for color injection.
  # After first login, open noctalia Settings → Color Scheme → Templates
  # and toggle GTK on. The gsettings sync (syncGsettings: true) keeps
  # GTK3/4 in sync automatically when noctalia regenerates the scheme.
  gtk = {
    enable = true;
    theme = {
      name    = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name    = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # Persist the theme and dark preference through dconf so apps that read
  # GSettings directly (e.g. Nautilus) pick it up without noctalia running.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme    = "adw-gtk3-dark";
      icon-theme   = "Adwaita";
      color-scheme = "prefer-dark";
    };
  };

  # qt6ct reads this to know which theme engine to use.
  # The system-level QT_QPA_PLATFORMTHEME=qt6ct is set in configuration.nix.
  # Adopt the new default: noctalia handles GTK4 theming via its color
  # sync, so we don't want home-manager to force the GTK3 theme onto GTK4.
  gtk.gtk4.theme = null;

  home.packages = [ pkgs.qt6Packages.qt6ct pkgs.nwg-look ];
}
