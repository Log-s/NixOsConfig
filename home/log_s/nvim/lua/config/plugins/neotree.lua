-- Neotree configuration
require("neo-tree").setup({
  close_if_last_window = false,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
    },
  },
  window = {
    position = "left",
    width = 30,
  },
  filesystem = {
    auto_open = false,
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = true,
    },
  window = {
    mappings = {
      ["<c-v>"] = "open_vsplit",
      ["<c-s>"] = "open_split",
    },
  },
})

