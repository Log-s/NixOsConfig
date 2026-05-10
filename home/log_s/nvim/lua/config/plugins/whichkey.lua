-- Which-key configuration
-- Shows keybinding hints as you type
local wk = require("which-key")

wk.setup({
  plugins = {
    marks = true, -- Shows marks when you hit ` or '
    registers = true, -- Shows registers when you hit " in NORMAL mode or <c-r> in INSERT mode
    spelling = {
      enabled = true, -- Enable spelling suggestions with z=
      suggestions = 20, -- How many suggestions should be shown?
    },
    presets = {
      operators = true, -- Help for operators like d, y, ...
      motions = true, -- Help for motions
      text_objects = true, -- Help for text objects triggered after entering an operator
      windows = true, -- Default bindings on <c-w>
      nav = true, -- Misc bindings to work with windows
      z = true, -- Bindings for folds, spelling and others prefixed with z
      g = true, -- Bindings for prefixed with g
    },
  },
  win = {
    border = "rounded", -- none, single, double, shadow, rounded
    padding = { 1, 2 }, -- padding [top/bottom, left/right]
    title = true,
    title_pos = "center",
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = {
    { "<auto>", mode = "nixsotc" }, -- automatically setup triggers for all modes
  },
  icons = {
    group = "", -- symbol used for a group
    separator = "➜", -- symbol used between a key and it's label
    mappings = false, -- disable automatic icon detection
  },
})

-- Register keymaps with group labels (icons included in group names for consistency)
wk.add({
  { "<leader>n", group = "󰉋 Neotree" },
  { "<leader>t", group = "󰦨 Toogle" },
  { "<leader>f", group = "󰈞 Find" },
  { "<leader>ff", group = "󰈔 Files" },
  { "<leader>fg", group = "󰍉 Grep" },
  { "<leader>fb", group = "󰓩 Buffers" },
  { "<leader>fh", group = "󰋼 Help tags" },
  { "<leader>c", group = "󰨷 Code" },
  { "<leader>cf", group = "󰨷 Format" },
  { "<leader>ca", group = "󰨷 Code action" },
  { "<leader>cr", group = "󰛷 Rename symbol" },
  { "<leader>cn", desc = "→ Next diagnostic" },
  { "<leader>cp", desc = "← Prev diagnostic" },
  { "<leader>D", group = "󰆍 Type definition" },
  { "<leader>w", group = "󰖲 Windows" },
  { "<leader>wa", group = "󰐗 Add workspace folder" },
  { "<leader>wr", group = "󰐖 Remove workspace folder" },
  { "<leader>wl", group = "󰒋 List workspace folders" },
  { "<leader>wv", group = "󰁌 Split vertically" },
  { "<leader>ws", group = "󰁍 Split horizontally" },
  { "<leader>wc", group = "󰅖 Close window" },
  -- Git (Diffview)
  { "<leader>g", group = "󰊢 Git" },
  { "<leader>gd", group = "󰊢 Open diff" },
  { "<leader>gc", group = "󰊢 Close diffview" },
  { "<leader>gh", group = "󰊢 File history (current)" },
  { "<leader>gH", group = "󰊢 File history (cwd)" },
  { "<leader>gt", group = "󰊢 Toggle file panel" },
  { "<leader>gf", group = "󰊢 Focus file panel" },
  { "<leader>gr", group = "󰊢 Refresh diffview" },
})
