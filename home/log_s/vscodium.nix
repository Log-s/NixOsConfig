{ pkgs, inputs, ... }:
let
  ext = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system};

  copyWithLineNumbers = pkgs.stdenv.mkDerivation {
    pname   = "vscode-extension-yassh-copy-with-line-numbers";
    version = "0.0.4";
    src     = ../../assets/extensions/yassh.copy-with-line-numbers-0.0.4.vsix;

    nativeBuildInputs = [ pkgs.unzip ];

    dontConfigure = true;
    dontBuild     = true;

    unpackPhase  = ''unzip -q "$src" -d unpacked'';
    installPhase = ''
      mkdir -p "$out/share/vscode/extensions/yassh.copy-with-line-numbers"
      cp -r unpacked/extension/. "$out/share/vscode/extensions/yassh.copy-with-line-numbers/"
    '';

    passthru = {
      vscodeExtPublisher = "yassh";
      vscodeExtName      = "copy-with-line-numbers";
      vscodeExtUniqueId  = "yassh.copy-with-line-numbers";
    };
  };
in {
  programs.vscodium = {
    enable     = true;
    profiles.default = {
      extensions = [
        ext.open-vsx.ms-python.python
        ext.open-vsx.ms-sarifvscode.sarif-viewer
        ext.open-vsx.catppuccin.catppuccin-vsc
        copyWithLineNumbers
      ];
      userSettings = {
        "editor.fontFamily"        = "'JetBrainsMono Nerd Font', monospace";
        "editor.fontSize"          = 13;
        "editor.fontLigatures"     = true;
        "editor.formatOnSave"      = true;
        "editor.minimap.enabled"   = false;
        "workbench.colorTheme"     = "Catppuccin Frappé";
        "telemetry.telemetryLevel" = "off";
      };
    };
  };
}
