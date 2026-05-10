{ lib, pkgs, ... }: {
  # Clone pentesting tools that are not in nixpkgs into ~/Tools/.
  # Runs only when the destination directory doesn't already exist,
  # so subsequent rebuilds are instant and local edits are preserved.
  home.activation.clonePentools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    clone_if_missing() {
      local dest="$1" url="$2"
      if [ ! -d "$dest" ]; then
        $DRY_RUN_CMD mkdir -p "$(dirname "$dest")"
        # Non-fatal: network may be unavailable at activation time.
        # Run `home-manager switch` manually once connected to finish cloning.
        $DRY_RUN_CMD ${lib.getExe pkgs.git} clone --depth=1 "$url" "$dest" || \
          echo "WARNING: could not clone $url (no network?) — retry with: git clone $url $dest"
      fi
    }

    clone_if_missing "$HOME/Tools/ad/krbrelayx"      "https://github.com/dirkjanm/krbrelayx"
    clone_if_missing "$HOME/Tools/ad/Responder"       "https://github.com/lgandx/Responder"
    clone_if_missing "$HOME/Tools/ad/impacket"        "https://github.com/fortra/impacket"
    clone_if_missing "$HOME/Tools/code/semgrep-rules" "https://github.com/semgrep/semgrep-rules"
  '';

  # Install pipx-based tools into isolated virtualenvs under ~/.local/share/pipx/.
  # Idempotent: skips packages whose venv directory already exists.
  # To add more tools, append to the list below.
  home.activation.pipxTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    pipx_install_if_missing() {
      local pkg="$1"
      if [ ! -d "$HOME/.local/share/pipx/venvs/$pkg" ]; then
        $DRY_RUN_CMD ${lib.getExe pkgs.pipx} install "$pkg" || \
          echo "WARNING: could not install $pkg via pipx — retry with: pipx install $pkg"
      fi
    }

    # semgrep is installed via pkgs.semgrep instead — the pipx wheel bundles a
    # generic Linux binary (osemgrep) that NixOS's dynamic linker cannot run.
    pipx_install_if_missing impacket
    pipx_install_if_missing dockerhound
  '';
}
