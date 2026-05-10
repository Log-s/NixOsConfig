-- Plugin configuration using lazy.nvim
require("lazy").setup({
	-- Catppuccin colorscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("config.plugins.catppuccin")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
		config = function()
			require("config.plugins.lualine")
		end,
	},

	-- Which-key (keybinding hints)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			require("config.plugins.whichkey")
		end,
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("config.plugins.neotree")
		end,
	},

	-- Auto pairs
	{
		"echasnovski/mini.pairs",
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},

	-- Treesitter (must load before Comment.nvim)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		priority = 1000,
		config = function()
			require("config.plugins.treesitter")
		end,
	},

	-- Comments (depends on treesitter)
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("config.plugins.ts-comments")
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("config.plugins.cmp")
		end,
	},

	-- LSP
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "pyright", "ts_ls", "rust_analyzer" },
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"black",
					"ruff",
					"eslint_d",
					"prettier",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason.nvim",
			"mason-lspconfig.nvim",
			"nvim-cmp",
		},
		config = function()
			require("config.plugins.lsp")
		end,
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("config.plugins.lint")
		end,
	},

	-- Formatting (includes Black)
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("config.plugins.conform")
		end,
	},

	-- Telescope (fuzzy finder)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("config.plugins.telescope")
		end,
	},

	-- Git diff view (single tabpage for all modified files, file history, merge tool)
	{
		"sindrets/diffview.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("config.plugins.diffview")
		end,
	},

	-- Floating command window with autosuggestions
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"nvim-cmp",
		},
		config = function()
			require("config.plugins.noice")
		end,
	},
})
