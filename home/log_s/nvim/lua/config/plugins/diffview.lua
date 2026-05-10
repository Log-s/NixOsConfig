-- Diffview.nvim: single tabpage interface for git diffs, file history, and merge conflicts
-- https://github.com/sindrets/diffview.nvim
local actions = require("diffview.actions")

require("diffview").setup({
	use_icons = true, -- nvim-web-devicons
	show_help_hints = true,
	watch_index = true,
	view = {
		default = {
			layout = "diff2_horizontal",
		},
		merge_tool = {
			layout = "diff3_horizontal",
		},
		file_history = {
			layout = "diff2_horizontal",
		},
	},
	file_panel = {
		listing_style = "tree",
		win_config = {
			position = "left",
			width = 35,
		},
	},
	keymaps = {
		disable_defaults = false,
		view = {
			-- Navigation between files in diff view
			{ "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
			{ "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
			{ "n", "[F", actions.select_first_entry, { desc = "First file" } },
			{ "n", "]F", actions.select_last_entry, { desc = "Last file" } },
			-- Open file from diff
			{ "n", "gf", actions.goto_file_edit, { desc = "Open in tab" } },
			{ "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open in split" } },
			{ "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open in new tab" } },
			-- Panel
			{ "n", "<leader>e", actions.focus_files, { desc = "Focus file panel" } },
			{ "n", "<leader>b", actions.toggle_files, { desc = "Toggle file panel" } },
			{ "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle layout" } },
			-- Merge conflict navigation
			{ "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
			{ "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
			-- Merge conflict resolution (choose version)
			{ "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose OURS" } },
			{ "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
			{ "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose BASE" } },
			{ "n", "<leader>ca", actions.conflict_choose("all"), { desc = "Choose ALL" } },
			{ "n", "dx", actions.conflict_choose("none"), { desc = "Delete conflict" } },
			{ "n", "<leader>cO", actions.conflict_choose_all("ours"), { desc = "Choose OURS (file)" } },
			{ "n", "<leader>cT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS (file)" } },
			{ "n", "<leader>cB", actions.conflict_choose_all("base"), { desc = "Choose BASE (file)" } },
			{ "n", "<leader>cA", actions.conflict_choose_all("all"), { desc = "Choose ALL (file)" } },
			{ "n", "dX", actions.conflict_choose_all("none"), { desc = "Delete conflict (file)" } },
		},
		file_panel = {
			{ "n", "j", actions.next_entry, { desc = "Next entry" } },
			{ "n", "k", actions.prev_entry, { desc = "Prev entry" } },
			{ "n", "<cr>", actions.select_entry, { desc = "Open diff" } },
			{ "n", "o", actions.select_entry, { desc = "Open diff" } },
			{ "n", "-", actions.toggle_stage_entry, { desc = "Stage / unstage" } },
			{ "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage" } },
			{ "n", "S", actions.stage_all, { desc = "Stage all" } },
			{ "n", "U", actions.unstage_all, { desc = "Unstage all" } },
			{ "n", "X", actions.restore_entry, { desc = "Restore file" } },
			{ "n", "R", actions.refresh_files, { desc = "Refresh" } },
		},
	},
})
