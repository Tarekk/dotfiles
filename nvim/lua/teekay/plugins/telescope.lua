return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local builtin = require("telescope.builtin")
		local transform_mod = require("telescope.actions.mt").transform_mod

		-- push search results to vim qflist
		-- this makes jumping across matched search files possilbe
		local custom_actions = transform_mod({
			to_qf = function(prompt_bufnr)
				local picker = action_state.get_current_picker(prompt_bufnr)
				local qf_entries = {}
				for entry in picker.manager:iter() do
					if entry.filename then
						table.insert(qf_entries, {
							filename = entry.filename,
							lnum = entry.lnum or 1,
							col = entry.col or 1,
							text = entry.text or "",
						})
					end
				end
				actions.close(prompt_bufnr)
				if #qf_entries > 0 then
					vim.fn.setqflist(qf_entries)
					local first = qf_entries[1]
					vim.cmd(string.format("edit +%d %s", first.lnum, first.filename))
					vim.cmd(string.format("normal! %d|", first.col))
				end
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<CR>"] = custom_actions.to_qf,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		local function search_in_directory(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			actions.close(prompt_bufnr)
			builtin.live_grep({ search_dirs = { selection.value } })
		end

		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", function()
			builtin.find_files({ hidden = true })
		end, { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>rf", builtin.lsp_references, { desc = "Find references" })

		-- navigate through qflist, no prev mappping, just use CTRL + I/O
		keymap.set("n", "<leader>q", "<cmd>cnext | normal! zz<CR>", { desc = "Next quickfix item" })

		-- useful for monorepos or big codebases. Select dir first and then grep search
		keymap.set("n", "<leader>fd", function()
			builtin.find_files({
				prompt_title = "Select Directory",
				find_command = { "find", ".", "-type", "d" },
				attach_mappings = function(prompt_bufnr, map)
					map("i", "<CR>", function()
						search_in_directory(prompt_bufnr)
					end)
					return true
				end,
			})
		end)
	end,
}
