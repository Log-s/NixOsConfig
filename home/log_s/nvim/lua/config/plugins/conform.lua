-- Conform.nvim configuration
require("conform").setup({
  formatters_by_ft = {
    python = { "black" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters = {
    black = {
      prepend_args = { "--line-length", "88" },
    },
    prettier = {
      prepend_args = { "--single-quote", "false", "--trailing-comma", "es5" },
    },
  },
})

