-- Telescope configuration
local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
    },
    preview = {
      treesitter = false, -- Disable treesitter highlighting to avoid ft_to_lang error
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = false,
    },
  },
  extensions = {},
})

