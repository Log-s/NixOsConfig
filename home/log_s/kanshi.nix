{ ... }: {
  services.kanshi = {
    enable = true;
    settings = [
      # Laptop only — eDP-1 at full resolution
      {
        profile = {
          name = "laptop-only";
          outputs = [
            { criteria = "eDP-1"; status = "enable"; mode = "2560x1440@60"; }
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
