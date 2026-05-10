-- Key mappings
local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable arrow-key navigation
keymap("n", "<Up>", ":echoe 'Get off my lawn!'<CR>")
keymap("n", "<Down>", ":echoe 'Get off my lawn!'<CR>")
keymap("n", "<Left>", ":echoe 'Get off my lawn!'<CR>")
keymap("n", "<Right>", ":echoe 'Get off my lawn!'<CR>")
keymap("i", "<Up>", "<C-o>:echoe 'Get off my lawn!'<CR>")
keymap("i", "<Down>", "<C-o>:echoe 'Get off my lawn!'<CR>")
keymap("i", "<Left>", "<C-o>:echoe 'Get off my lawn!'<CR>")
keymap("i", "<Right>", "<C-o>:echoe 'Get off my lawn!'<CR>")
keymap("v", "<Up>", ":<C-u>echoe 'Get off my lawn!'<CR>")
keymap("v", "<Down>", ":<C-u>echoe 'Get off my lawn!'<CR>")
keymap("v", "<Left>", ":<C-u>echoe 'Get off my lawn!'<CR>")
keymap("v", "<Right>", ":<C-u>echoe 'Get off my lawn!'<CR>")

-- Exit insert mode
keymap("i", "jj", "<Esc>", { noremap = false })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "󰁍 Left", noremap = true, silent = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "󰁅 Down", noremap = true, silent = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "󰁝 Up", noremap = true, silent = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "󰁔 Right", noremap = true, silent = true })

-- Diagnostic navigation
keymap("n", "<leader>cp", vim.diagnostic.goto_prev, { desc = "󰒕 Prev diagnostic", noremap = true, silent = true })
keymap("n", "<leader>cn", vim.diagnostic.goto_next, { desc = "󰒔 Next diagnostic", noremap = true, silent = true })

-- Toggle diagnostic display
keymap("n", "<leader>tv", function()
	local config = vim.diagnostic.config()
	local current = config.virtual_text
	vim.diagnostic.config({ virtual_text = not current })
	vim.notify("Virtual text: " .. (not current and "on" or "off"), vim.log.levels.INFO)
end, { desc = "󰒕 Virtual text", noremap = true, silent = true })

keymap("n", "<leader>ts", function()
	local config = vim.diagnostic.config()
	local current = config.signs
	vim.diagnostic.config({ signs = not current })
	vim.notify("Diagnostic signs: " .. (not current and "on" or "off"), vim.log.levels.INFO)
end, { desc = "󰒔 Signs", noremap = true, silent = true })

keymap("n", "<leader>tu", function()
	local config = vim.diagnostic.config()
	local current = config.underline
	vim.diagnostic.config({ underline = not current })
	vim.notify("Underline: " .. (not current and "on" or "off"), vim.log.levels.INFO)
end, { desc = "󰒓 Underline", noremap = true, silent = true })

-- Toggle all diagnostics at once
keymap("n", "<leader>td", function()
	local config = vim.diagnostic.config()
	local all_off = not config.virtual_text and not config.signs and not config.underline
	vim.diagnostic.config({
		virtual_text = all_off,
		signs = all_off,
		underline = all_off,
	})
	vim.notify("All diagnostics: " .. (all_off and "on" or "off"), vim.log.levels.INFO)
end, { desc = "󰒒 All diagnostics", noremap = true, silent = true })

-- File explorer (Neotree)
keymap("n", "<leader>n", function()
	local ok, neo_tree = pcall(require, "neo-tree.command")
	if ok then
		neo_tree.execute({ toggle = true })
	else
		vim.notify("Neo-tree not loaded", vim.log.levels.WARN)
	end
end, { desc = "󰉋 Toggle explorer", noremap = true, silent = true })

-- Toggle line numbers
keymap("n", "<leader>tn", function()
	vim.opt.number = not vim.opt.number:get()
end, { desc = "󰎠 Line numbers", noremap = true, silent = true })

-- Toggle relative line numbers
keymap("n", "<leader>tr", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "󰦨 Relative line numbers", noremap = true, silent = true })

-- Telescope (fuzzy finder)
keymap("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "󰈔 Files", noremap = true, silent = true })

keymap("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "󰍉 Grep", noremap = true, silent = true })

keymap("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "󰓩 Buffers", noremap = true, silent = true })

keymap("n", "<leader>fh", function()
	require("telescope.builtin").help_tags()
end, { desc = "󰋼 Help tags", noremap = true, silent = true })

-- Window splitting
keymap("n", "<leader>wv", function()
	vim.cmd("vsplit")
end, { desc = "󰁌 Split vertical", noremap = true, silent = true })

keymap("n", "<leader>ws", function()
	vim.cmd("split")
end, { desc = "󰁍 Split horizontal", noremap = true, silent = true })

keymap("n", "<leader>wc", function()
	vim.cmd("close")
end, { desc = "󰅖 Close", noremap = true, silent = true })

-- Format code
keymap("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "󰉼 Format", noremap = true, silent = true })

-- Git / Diffview (open, close, file history, panel)
keymap("n", "<leader>gd", function()
	vim.cmd("DiffviewOpen")
end, { desc = "󰊢 Open diff (all changes)", noremap = true, silent = true })

keymap("n", "<leader>gc", function()
	vim.cmd("DiffviewClose")
end, { desc = "󰊢 Close diffview", noremap = true, silent = true })

keymap("n", "<leader>gh", function()
	vim.cmd("DiffviewFileHistory %")
end, { desc = "󰊢 File history (current file)", noremap = true, silent = true })

keymap("n", "<leader>gH", function()
	vim.cmd("DiffviewFileHistory")
end, { desc = "󰊢 File history (cwd)", noremap = true, silent = true })

keymap("n", "<leader>gt", function()
	vim.cmd("DiffviewToggleFiles")
end, { desc = "󰊢 Toggle file panel", noremap = true, silent = true })

keymap("n", "<leader>gf", function()
	vim.cmd("DiffviewFocusFiles")
end, { desc = "󰊢 Focus file panel", noremap = true, silent = true })

keymap("n", "<leader>gr", function()
	vim.cmd("DiffviewRefresh")
end, { desc = "󰊢 Refresh diffview", noremap = true, silent = true })

-- LSP keymaps (set when LSP attaches to a buffer)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local buf_opts = { buffer = ev.buf, noremap = true, silent = true }
		keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", buf_opts, { desc = "󰆍 Declaration" }))
		keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", buf_opts, { desc = "󰆏 Definition" }))
		keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", buf_opts, { desc = "󰋼 Hover docs" }))
		keymap(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", buf_opts, { desc = "󰆎 Implementation" })
		)
		keymap("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", buf_opts, { desc = "󰏪 Signature" }))
		keymap(
			"n",
			"<leader>wa",
			vim.lsp.buf.add_workspace_folder,
			vim.tbl_extend("force", buf_opts, { desc = "󰐗 Add folder" })
		)
		keymap(
			"n",
			"<leader>wr",
			vim.lsp.buf.remove_workspace_folder,
			vim.tbl_extend("force", buf_opts, { desc = "󰐖 Remove folder" })
		)
		keymap("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, vim.tbl_extend("force", buf_opts, { desc = "󰒋 List folders" }))
		keymap(
			"n",
			"<leader>D",
			vim.lsp.buf.type_definition,
			vim.tbl_extend("force", buf_opts, { desc = "󰆍 Type def" })
		)
		keymap("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", buf_opts, { desc = "󰛷 Rename" }))
		keymap(
			{ "n", "v" },
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", buf_opts, { desc = "󰌶 Code action" })
		)
		keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", buf_opts, { desc = "󰈇 References" }))
	end,
})
