{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, config, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };

    # Symlink the wrapper-modules-generated config.kdl into ~/.config/niri/
    # so noctalia's keybind-cheatsheet plugin can find and parse it.
    system.activationScripts.niriConfigLink = {
      text = ''
        config_kdl="${config.programs.niri.package}/niri-config.kdl"
        if [ -f "$config_kdl" ]; then
          mkdir -p /home/log_s/.config/niri
          chown log_s:users /home/log_s/.config/niri
          chmod 755 /home/log_s/.config/niri
          # Remove a stale symlink left by a previous ln -sf activation;
          # without this the shell follows the symlink into the read-only
          # nix store and the redirect fails with EROFS.
          [ -L /home/log_s/.config/niri/config.kdl ] && \
            rm /home/log_s/.config/niri/config.kdl
          # wrapper-modules quotes all KDL identifiers (e.g. "binds", "Mod+H").
          # noctalia's keybind-cheatsheet expects bare identifiers — strip the
          # leading quotes from node names while leaving string values intact.
          ${pkgs.gnused}/bin/sed -E 's/^([[:space:]]*)"([^"]+)"/\1\2/' "$config_kdl" \
            > /home/log_s/.config/niri/config.kdl
          chown log_s:users /home/log_s/.config/niri/config.kdl
          chmod 644 /home/log_s/.config/niri/config.kdl
        fi
      '';
      deps = [];
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        prefer-no-csd = _: {};

        input = {
          keyboard.xkb.layout = "fr";
          touchpad = {
            tap = _: {};
            natural-scroll = _: {};
          };
        };

        cursor.hide-after-inactive-ms = 3000;

        layout = {
          gaps = 8;
          border = {
            width = 2;
            active-color = "#89b4fa";
            inactive-color = "#45475a";
          };
          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];
          default-column-width.proportion = 0.5;
          focus-ring.off = _: {};
        };

        window-rules = [{
          geometry-corner-radius = 10;
          clip-to-geometry = true;
        }];

        # layer-rules match uses KDL attributes which wrapper-modules can't express — skipped
        # layer-rule { match namespace="^noctalia-overview*"; place-within-backdrop true; }

        debug.honor-xdg-activation-with-invalid-serial = _: {};

        binds = {
          # Focus navigation
          "Mod+H".focus-column-left = _: {};
          "Mod+L".focus-column-right = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+J".focus-window-down = _: {};

          # Move windows
          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+L".move-column-right = _: {};
          "Mod+Shift+K".move-window-up-or-to-workspace-up = _: {};
          "Mod+Shift+J".move-window-down-or-to-workspace-down = _: {};

          # Workspaces — AZERTY unshifted number row
          "Mod+ampersand".focus-workspace = 1;
          "Mod+eacute".focus-workspace = 2;
          "Mod+quotedbl".focus-workspace = 3;
          "Mod+apostrophe".focus-workspace = 4;
          "Mod+parenleft".focus-workspace = 5;
          "Mod+minus".focus-workspace = 6;
          "Mod+egrave".focus-workspace = 7;
          "Mod+underscore".focus-workspace = 8;
          "Mod+ccedilla".focus-workspace = 9;

          "Mod+Shift+ampersand".move-column-to-workspace = 1;
          "Mod+Shift+eacute".move-column-to-workspace = 2;
          "Mod+Shift+quotedbl".move-column-to-workspace = 3;
          "Mod+Shift+apostrophe".move-column-to-workspace = 4;
          "Mod+Shift+parenleft".move-column-to-workspace = 5;
          "Mod+Shift+minus".move-column-to-workspace = 6;
          "Mod+Shift+egrave".move-column-to-workspace = 7;
          "Mod+Shift+underscore".move-column-to-workspace = 8;
          "Mod+Shift+ccedilla".move-column-to-workspace = 9;

          "Mod+Ctrl+J".focus-workspace-down = _: {};
          "Mod+Ctrl+K".focus-workspace-up = _: {};

          # Layout & resize
          "Mod+R".switch-preset-column-width = _: {};
          "Mod+Alt+H".set-column-width = "-10%";
          "Mod+Alt+L".set-column-width = "+10%";
          "Mod+Alt+K".set-window-height = "-10%";
          "Mod+Alt+J".set-window-height = "+10%";
          "Mod+F".fullscreen-window = _: {};
          "Mod+Shift+F".maximize-column = _: {};
          "Mod+E".expel-window-from-column = _: {};
          "Mod+Shift+E".consume-window-into-column = _: {};

          # Floating
          "Mod+V".toggle-window-floating = _: {};
          "Mod+Shift+Space".switch-focus-between-floating-and-tiling = _: {};

          # Launch
          "Mod+Return".spawn-sh = lib.getExe pkgs.alacritty;
          "Mod+Shift+Return".spawn-sh = lib.getExe pkgs.firefox;
          "Mod+Shift+N".spawn-sh = lib.getExe pkgs.nautilus;
          "Mod+Shift+comma".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call plugin:keybind-cheatsheet toggle";
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

          # Noctalia
          "Mod+C".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call settings toggle";

          # Session
          "Mod+Shift+Q".close-window = _: {};
          "Mod+Tab".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher windows";
          "Mod+Escape".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call lockScreen lock";
          "Mod+Shift+S".spawn-sh = "${pkgs.zenity}/bin/zenity --question --title='Suspend' --text='Suspend the system?' --default-cancel && systemctl suspend";
          "Mod+Shift+P".spawn-sh = "${pkgs.zenity}/bin/zenity --question --title='Power off' --text='Shut down the system?' --default-cancel && systemctl poweroff";
          "Mod+Shift+B".spawn-sh = "${pkgs.zenity}/bin/zenity --question --title='Reboot' --text='Reboot the system?' --default-cancel && systemctl reboot";
          "Mod+Shift+X".quit = _: {};

          # Screenshots
          "Print".screenshot = _: {};
          "Ctrl+Print".screenshot-screen = _: {};
          "Alt+Print".screenshot-window = _: {};

          # Media keys (allow-when-locked not supported by wrapper-modules — add via hotfix later)
          "XF86AudioRaiseVolume".spawn-sh  = "${lib.getExe self'.packages.myNoctalia} ipc call volume increase";
          "XF86AudioLowerVolume".spawn-sh  = "${lib.getExe self'.packages.myNoctalia} ipc call volume decrease";
          "XF86AudioMute".spawn-sh         = "${lib.getExe self'.packages.myNoctalia} ipc call volume muteOutput";
          "XF86AudioMicMute".spawn-sh      = "${lib.getExe self'.packages.myNoctalia} ipc call volume muteMic";
          "XF86MonBrightnessUp".spawn-sh   = "${lib.getExe self'.packages.myNoctalia} ipc call brightness increase";
          "XF86MonBrightnessDown".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call brightness decrease";
        };
      };
    };
  };
}
