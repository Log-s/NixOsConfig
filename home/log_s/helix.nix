{ ... }: {
  programs.helix = {
    enable = true;

    settings.theme = "noctalia_dracula";

    themes.noctalia_dracula = {
      # ── UI ──────────────────────────────────────────────────────────────────
      "ui.background"           = { bg = "background"; };
      "ui.background.separator" = { fg = "outline"; };

      "ui.statusline"          = { fg = "on_surface";   bg = "surface_variant"; };
      "ui.statusline.normal"   = { fg = "on_primary";   bg = "primary"; };
      "ui.statusline.insert"   = { fg = "on_tertiary";  bg = "tertiary"; };
      "ui.statusline.select"   = { fg = "on_secondary"; bg = "secondary"; };
      "ui.statusline.inactive" = { fg = "outline";      bg = "surface_variant"; };

      "ui.cursor"         = { fg = "cursor_text"; bg = "cursor"; };
      "ui.cursor.primary" = { fg = "cursor_text"; bg = "cursor"; };
      "ui.cursor.match"   = { fg = "background";  bg = "tertiary"; modifiers = ["bold"]; };
      "ui.cursor.insert"  = { fg = "cursor_text"; bg = "tertiary"; };
      "ui.cursor.select"  = { fg = "cursor_text"; bg = "secondary"; };

      "ui.selection"         = { bg = "selection_bg"; };
      "ui.selection.primary" = { fg = "selection_fg"; bg = "selection_bg"; };

      "ui.linenr"          = { fg = "outline"; };
      "ui.linenr.selected" = { fg = "on_surface_variant"; modifiers = ["bold"]; };

      "ui.text"          = { fg = "foreground"; };
      "ui.text.focus"    = { fg = "primary"; modifiers = ["bold"]; };
      "ui.text.inactive" = { fg = "outline"; };
      "ui.text.info"     = { fg = "tertiary"; };

      "ui.virtual.ruler"       = { bg = "surface_variant"; };
      "ui.virtual.whitespace"  = { fg = "outline"; };
      "ui.virtual.indent-guide"= { fg = "outline"; };
      "ui.virtual.inlay-hint"  = { fg = "outline"; modifiers = ["italic"]; };
      "ui.virtual.jump-label"  = { fg = "secondary"; modifiers = ["bold" "underlined"]; };

      "ui.window" = { fg = "outline"; };

      "ui.popup"      = { fg = "on_surface"; bg = "surface_variant"; };
      "ui.popup.info" = { fg = "on_surface"; bg = "surface_variant"; };

      "ui.menu"          = { fg = "on_surface"; bg = "surface_variant"; };
      "ui.menu.selected" = { fg = "on_primary"; bg = "primary"; };
      "ui.menu.scroll"   = { fg = "outline"; };

      "ui.help" = { fg = "on_surface"; bg = "surface_variant"; };

      "ui.highlight"           = { bg = "selection_bg"; };
      "ui.highlight.frameline" = { bg = "surface_variant"; };

      "ui.gutter"          = { bg = "background"; };
      "ui.gutter.selected" = { bg = "surface_variant"; };

      # ── Diagnostics ──────────────────────────────────────────────────────────
      "diagnostic.error"   = { underline = { color = "error";    style = "curl"; }; };
      "diagnostic.warning" = { underline = { color = "yellow";   style = "curl"; }; };
      "diagnostic.info"    = { underline = { color = "tertiary"; style = "curl"; }; };
      "diagnostic.hint"    = { underline = { color = "primary";  style = "curl"; }; };

      "error"   = { fg = "error"; };
      "warning" = { fg = "yellow"; };
      "info"    = { fg = "tertiary"; };
      "hint"    = { fg = "primary"; };

      # ── Diff / VCS ───────────────────────────────────────────────────────────
      "diff.plus"        = { fg = "green"; };
      "diff.minus"       = { fg = "error"; };
      "diff.delta"       = { fg = "yellow"; };
      "diff.delta.moved" = { fg = "tertiary"; };

      # ── Syntax ───────────────────────────────────────────────────────────────
      "attribute" = { fg = "primary"; };

      "type"             = { fg = "tertiary"; };
      "type.builtin"     = { fg = "tertiary"; modifiers = ["italic"]; };
      "type.enum.variant"= { fg = "primary"; };

      "constructor" = { fg = "primary"; };

      "constant"                  = { fg = "primary"; };
      "constant.builtin"          = { fg = "primary"; modifiers = ["italic"]; };
      "constant.builtin.boolean"  = { fg = "primary"; modifiers = ["italic"]; };
      "constant.character"        = { fg = "yellow"; };
      "constant.character.escape" = { fg = "secondary"; };
      "constant.numeric"          = { fg = "primary"; };
      "constant.numeric.float"    = { fg = "primary"; };

      "string"                = { fg = "yellow"; };
      "string.regexp"         = { fg = "tertiary"; };
      "string.special"        = { fg = "secondary"; };
      "string.special.path"   = { fg = "green"; };
      "string.special.url"    = { fg = "tertiary"; modifiers = ["underlined"]; };
      "string.special.symbol" = { fg = "secondary"; };

      "comment"                    = { fg = "bright_black"; modifiers = ["italic"]; };
      "comment.line"               = { fg = "bright_black"; modifiers = ["italic"]; };
      "comment.block"              = { fg = "bright_black"; modifiers = ["italic"]; };
      "comment.block.documentation"= { fg = "bright_black"; modifiers = ["italic"]; };

      "variable"              = { fg = "foreground"; };
      "variable.builtin"      = { fg = "primary";          modifiers = ["italic"]; };
      "variable.parameter"    = { fg = "on_surface_variant"; modifiers = ["italic"]; };
      "variable.other.member" = { fg = "foreground"; };

      "label" = { fg = "tertiary"; };

      "punctuation"         = { fg = "on_surface_variant"; };
      "punctuation.bracket" = { fg = "on_surface_variant"; };
      "punctuation.delimiter"= { fg = "on_surface_variant"; };
      "punctuation.special" = { fg = "secondary"; };

      "keyword"                      = { fg = "secondary"; };
      "keyword.control"              = { fg = "secondary"; };
      "keyword.control.conditional"  = { fg = "secondary"; modifiers = ["italic"]; };
      "keyword.control.repeat"       = { fg = "secondary"; modifiers = ["italic"]; };
      "keyword.control.import"       = { fg = "secondary"; };
      "keyword.control.return"       = { fg = "secondary"; };
      "keyword.control.exception"    = { fg = "secondary"; };
      "keyword.operator"             = { fg = "secondary"; };
      "keyword.directive"            = { fg = "secondary"; };
      "keyword.function"             = { fg = "secondary"; };
      "keyword.storage"              = { fg = "secondary"; };
      "keyword.storage.type"         = { fg = "tertiary"; };
      "keyword.storage.modifier"     = { fg = "secondary"; };

      "operator" = { fg = "secondary"; };

      "function"                = { fg = "green"; };
      "function.builtin"        = { fg = "green"; modifiers = ["italic"]; };
      "function.method"         = { fg = "green"; };
      "function.method.private" = { fg = "green"; modifiers = ["italic"]; };
      "function.macro"          = { fg = "green"; };
      "function.special.builtin"= { fg = "green"; modifiers = ["italic"]; };

      "tag"         = { fg = "secondary"; };
      "tag.builtin" = { fg = "secondary"; };
      "tag.attribute"= { fg = "primary"; };
      "tag.error"   = { fg = "error"; };

      "namespace" = { fg = "tertiary"; modifiers = ["italic"]; };
      "special"   = { fg = "secondary"; };

      "markup.heading"        = { fg = "primary";      modifiers = ["bold"]; };
      "markup.heading.1"      = { fg = "primary";      modifiers = ["bold" "underlined"]; };
      "markup.heading.2"      = { fg = "secondary";    modifiers = ["bold"]; };
      "markup.heading.3"      = { fg = "tertiary";     modifiers = ["bold"]; };
      "markup.heading.4"      = { fg = "green";        modifiers = ["bold"]; };
      "markup.heading.5"      = { fg = "yellow";       modifiers = ["bold"]; };
      "markup.heading.6"      = { fg = "bright_black"; modifiers = ["bold"]; };
      "markup.heading.marker" = { fg = "outline"; };
      "markup.list"           = { fg = "secondary"; };
      "markup.list.unnumbered"= { fg = "secondary"; };
      "markup.list.numbered"  = { fg = "secondary"; };
      "markup.list.checked"   = { fg = "green"; };
      "markup.list.unchecked" = { fg = "outline"; };
      "markup.bold"           = { modifiers = ["bold"]; };
      "markup.italic"         = { modifiers = ["italic"]; };
      "markup.strikethrough"  = { modifiers = ["crossed_out"]; };
      "markup.link"           = { fg = "tertiary"; modifiers = ["underlined"]; };
      "markup.link.url"       = { fg = "tertiary"; modifiers = ["underlined"]; };
      "markup.link.label"     = { fg = "primary"; };
      "markup.link.text"      = { fg = "foreground"; };
      "markup.quote"          = { fg = "bright_black"; modifiers = ["italic"]; };
      "markup.raw"            = { fg = "yellow"; };
      "markup.raw.block"      = { fg = "foreground"; };
      "markup.raw.inline"     = { fg = "yellow"; };
      "markup.normal"         = { fg = "foreground"; };

      # ── Palette ──────────────────────────────────────────────────────────────
      palette = {
        background         = "#282A36";
        surface_variant    = "#44475A";
        outline            = "#5a5e77";

        foreground         = "#F8F8F2";
        on_surface         = "#F8F8F2";
        on_surface_variant = "#d6d8e0";

        primary            = "#bd93f9";
        on_primary         = "#282A36";

        secondary          = "#ff79c6";
        on_secondary       = "#4e1d32";

        tertiary           = "#8be9fd";
        on_tertiary        = "#003543";

        error              = "#FF5555";
        on_error           = "#282A36";

        black              = "#21222c";
        red                = "#ff5555";
        green              = "#50fa7b";
        yellow             = "#f1fa8c";
        blue               = "#bd93f9";
        magenta            = "#ff79c6";
        cyan               = "#8be9fd";
        white              = "#f8f8f2";
        bright_black       = "#6272a4";
        bright_red         = "#ff6e6e";
        bright_green       = "#69ff94";
        bright_yellow      = "#ffffa5";
        bright_blue        = "#d6acff";
        bright_magenta     = "#ff92df";
        bright_cyan        = "#a4ffff";
        bright_white       = "#ffffff";

        cursor             = "#f8f8f2";
        cursor_text        = "#282a36";
        selection_fg       = "#ffffff";
        selection_bg       = "#44475a";
      };
    };
  };
}
