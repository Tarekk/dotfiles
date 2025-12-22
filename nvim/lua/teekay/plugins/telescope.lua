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
				local selection = action_state.get_selected_entry()
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
				local selected_filename = selection.filename
				local selected_lnum = selection.lnum or 1
				local selected_col = selection.col or 1
				actions.close(prompt_bufnr)
				if #qf_entries > 0 then
					vim.fn.setqflist(qf_entries)
					-- Jump to selected file instead of first entry
					if #qf_entries > 0 then
						vim.fn.setqflist(qf_entries)
						-- Jump to the selected file using stored values
						vim.cmd(string.format("edit +%d %s", selected_lnum, selected_filename))
						vim.cmd(string.format("normal! %d|", selected_col))
					end
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
						["<C-v>"] = function(prompt_bufnr)
							-- This will close the prompt first
							actions.close(prompt_bufnr)
							-- Get the current selection
							local selection = action_state.get_selected_entry()
							-- Open the file in a vertical split on the right
							vim.cmd("botright vsplit")
							vim.cmd(string.format("edit %s", selection.path))
						end,
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
		keymap.set("n", "<leader>fv", function()
			builtin.buffers({
				-- Optional customizations for a better buffer picker
				sort_mru = true, -- Sort by most recently used first
				sort_lastused = true, -- Same as above, more explicit
				ignore_current_buffer = true, -- Don't show the buffer you're currently in at the top
				show_all_buffers = false, -- Only show listed (visible) buffers
				previewer = true, -- Show preview of buffer content
				prompt_title = "Open Buffers",
				path_display = { "smart" }, -- Consistent with your defaults
				-- Optional: delete buffer with <C-d> (requires telescope-actions or default)
				attach_mappings = function(prompt_bufnr, map)
					-- Delete buffer with Ctrl-d (closes the buffer properly)
					map("i", "<C-d>", function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						if selection then
							vim.api.nvim_buf_delete(selection.bufnr, { force = false })
						end
					end)
					map("n", "<C-d>", function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						if selection then
							vim.api.nvim_buf_delete(selection.bufnr, { force = false })
						end
					end)
					return true
				end,
			})
		end, { desc = "Fuzzy find open buffers" })
		keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>rf", builtin.lsp_references, { desc = "Find references" })
		keymap.set("n", "<leader>p", function()
			local word = vim.fn.expand("<cword>")
			-- First, find all files in prompts/
			local find_cmd = vim.fn.systemlist({
				"find",
				".",
				"(",
				"-path",
				"*/.*",
				"-o",
				"-path",
				"*/node_modules/*",
				"-o",
				"-path",
				"*/dist/*",
				"-o",
				"-path",
				"*/build/*",
				")",
				"-prune",
				"-o",
				"-path",
				"*/prompts/*",
				"-type",
				"f",
				"-print",
			})

			-- Check for exact filename matches
			local exact_matches = {}
			for _, file in ipairs(find_cmd) do
				local filename = vim.fn.fnamemodify(file, ":t")
				if filename == word or filename:match("^" .. vim.pesc(word) .. "%.") then
					table.insert(exact_matches, file)
				end
			end

			-- If exactly one exact match, open it directly
			if #exact_matches == 1 then
				vim.cmd("edit " .. exact_matches[1])
			else
				-- Otherwise show telescope picker
				builtin.find_files({
					find_command = {
						"find",
						".",
						"(",
						"-path",
						"*/.*",
						"-o",
						"-path",
						"*/node_modules/*",
						"-o",
						"-path",
						"*/dist/*",
						"-o",
						"-path",
						"*/build/*",
						")",
						"-prune",
						"-o",
						"-path",
						"*/prompts/*",
						"-type",
						"f",
						"-print",
					},
					default_text = word,
				})
			end
		end, { desc = "Find files in prompts/ matching word under cursor" })

		-- Override gd for markdown files to search for Jinja2 function definitions
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "jinja", "html.jinja", "jinja2" },
			callback = function()
				keymap.set("n", "gd", function()
					local word = vim.fn.expand("<cword>")
					builtin.grep_string({
						search = "def " .. word,
						use_regex = false,
					})
				end, { buffer = true, desc = "Jump to Jinja2 function definition" })
			end,
		})
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
