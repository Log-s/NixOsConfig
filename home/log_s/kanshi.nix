{ ... }: {
  services.kanshi = {
    enable = true;
    settings = [
      # Laptop only — eDP-1 at full resolution
      {
        profile = {
          name = "laptop-only";
          outputs = [
            { criteria = "eDP-1"; status = "enable"; mode = "3840x2160@59.997"; }
          ];
        };
      }

      # Dual external at 1080p 60 Hz, side by side, same baseline — internal display off
      {
        profile = {
          name = "dual-1080p";
          outputs = [
            { criteria = "eDP-1"; status = "disable"; }
            { criteria = "DP-5"; status = "enable"; mode = "1920x1080@60.000"; position = "0,0"; }
            { criteria = "DP-4"; status = "enable"; mode = "1920x1080@60.000"; position = "1920,0"; }
          ];
        };
      }

      # DP-5 (1080p) left, DP-4 (1440p) right, vertically centered — switch with: kanshictl switch mixed-external
      {
        profile = {
          name = "mixed-external";
          outputs = [
            { criteria = "eDP-1"; status = "disable"; }
            { criteria = "DP-5"; status = "enable"; mode = "1920x1080@59.940"; position = "0,180"; }
            { criteria = "DP-4"; status = "enable"; mode = "2560x1440@59.951"; position = "1920,0"; }
          ];
        };
      }

      # DP-5 (1440p) left, DP-4 (1440p) right, vertically centered — switch with: kanshictl switch mixed-external-full
      {
        profile = {
          name = "mixed-external-full";
          outputs = [
            { criteria = "eDP-1"; status = "disable"; }
            { criteria = "DP-5"; status = "enable"; mode = "2560x1440@59.961"; position = "0,180"; }
            { criteria = "DP-4"; status = "enable"; mode = "2560x1440@59.951"; position = "2560,0"; }
          ];
        };
      }
    ];
  };
}
