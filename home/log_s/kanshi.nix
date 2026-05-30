{ ... }: {
  services.kanshi = {
    enable = true;
    settings = [
      # Laptop only — eDP-1 forced to 1920x1080 @ scale 1.
      # The panel's EDID only advertises 4K, so we need `--custom` to tell
      # kanshi/niri to create a custom mode rather than pick one from the list.
      {
        profile = {
          name = "laptop-only";
          outputs = [
            { criteria = "eDP-1"; status = "enable"; mode = "--custom 1920x1080@60Hz"; scale = 1.0; }
          ];
        };
      }

      # DP-5 (1080p) left, DP-4 (1440p) right, vertically centered — switch with: kanshictl switch home-dual
      {
        profile = {
          name = "home-dual";
          outputs = [
            { criteria = "eDP-1"; status = "disable"; }
            { criteria = "DP-5"; status = "enable"; mode = "1920x1080@59.940"; position = "0,180"; }
            { criteria = "DP-4"; status = "enable"; mode = "2560x1440@59.951"; position = "1920,0"; }
          ];
        };
      }
    ];
  };
}
