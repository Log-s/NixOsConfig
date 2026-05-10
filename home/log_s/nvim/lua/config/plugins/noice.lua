-- Noice.nvim configuration (floating command window with autocompletion)
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    signature = {
      enabled = false,
    },
    hover = {
      enabled = false,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    format = {
      cmdline = { icon = "  " },
      search_down = { icon = "  " },
      search_up = { icon = "  " },
      filter = { icon = "  " },
      lua = { icon = "  " },
      help = { icon = "  " },
    },
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})

