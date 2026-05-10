require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "lua", "vim", "vimdoc" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})

