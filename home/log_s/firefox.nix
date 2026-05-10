{ pkgs, lib, ... }:
let
  # NUR is applied as an overlay in packages.nix so pkgs.nur inherits the
  # system nixpkgs config (allowUnfree = true, etc.).
  # Browse available addons: https://nur.nix-community.org/repos/rycee/
  addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  # Run pywalfox install once per pywalfox-native version so the extension
  # can find its native messaging host. nativeMessagingHosts handles the
  # manifest placement; this creates any additional files pywalfox needs.
  home.activation.pywalfoxInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${lib.getExe pkgs.pywalfox-native} install || true
  '';

  programs.firefox = {
    enable = true;

    # Keep legacy profile path so pywalfox (which hardcodes ~/.mozilla/firefox) works.
    configPath = ".mozilla/firefox";

    # Register native messaging hosts so Firefox can discover them.
    # Without this, the manifest is never found even if the package is on PATH.
    nativeMessagingHosts = [ pkgs.pywalfox-native ];

    profiles.default = {
      isDefault = true;

      extensions.packages = [
        # Browse addons at https://nur.nix-community.org/repos/rycee/
        addons.dashlane
        addons.pwnfox
        addons.pywalfox
      ];

      settings = {
        "browser.startup.homepage"           = "about:blank";
        "browser.newtabpage.enabled"         = false;
        "privacy.trackingprotection.enabled" = true;
        "extensions.autoDisableScopes"       = 0;
      };
    };
  };
}
