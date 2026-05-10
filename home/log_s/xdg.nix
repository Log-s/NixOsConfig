{ config, lib, ... }: {
  # Redirect all XDG user dirs except Downloads and Documents to $HOME itself
  # so xdg-user-dirs-update stops re-creating Desktop, Music, Pictures, etc.
  xdg.userDirs = {
    enable              = true;
    createDirectories   = true;
    setSessionVariables = false;
    desktop    = "${config.home.homeDirectory}";
    documents  = "${config.home.homeDirectory}/Documents";
    download   = "${config.home.homeDirectory}/Downloads";
    music      = "${config.home.homeDirectory}";
    pictures   = "${config.home.homeDirectory}";
    publicShare = "${config.home.homeDirectory}";
    templates  = "${config.home.homeDirectory}";
    videos     = "${config.home.homeDirectory}";
  };

  # Override the broken upstream desktop entry for caido-desktop.
  # The nixpkgs package ships Exec=AppRun (AppImage bootstrap, not on PATH).
  # caido-desktop is the proper nixpkgs-generated wrapper.
  xdg.desktopEntries.caido = {
    name    = "Caido";
    exec    = "caido-desktop --no-sandbox %U";
    terminal = false;
    icon    = "caido";
    comment = "Official desktop application for Caido";
    categories = [ "Network" ];
  };

  # Remove the stale XDG directories on first activation.
  # Uses rmdir (not rm -rf) so it only removes them if they are empty —
  # no data loss risk.
  home.activation.cleanHomeDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for d in Desktop Music Pictures Videos Templates "Public" Projects; do
      dir="$HOME/$d"
      if [ -d "$dir" ]; then
        $DRY_RUN_CMD rmdir --ignore-fail-on-non-empty "$dir"
      fi
    done
  '';
}
