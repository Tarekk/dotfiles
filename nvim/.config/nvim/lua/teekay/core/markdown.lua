vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.formatoptions:append("ro")
		vim.opt_local.comments = "b:-"

		-- Configure list detection and indentation
		vim.opt_local.formatlistpat = [[\s*-\s.*]] -- Pattern to identify list items
		vim.opt_local.breakindent = true
		vim.opt_local.breakindentopt = "list:2" -- Use list mode with negative shift to align with text

		-- Function to indent unindented bullet points
		-- local function indent_unindented_bullets()
		-- 	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		-- 	local modified_lines = {}
		-- 	for _, line in ipairs(lines) do
		-- 		if line:match("^%-[^-]") then -- Match single dash not followed by another dash
		-- 			table.insert(modified_lines, "  " .. line)
		-- 		else
		-- 			table.insert(modified_lines, line)
		-- 		end
		-- 	end
		-- 	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
		-- end
		-- -- Create autocmds for buffer
		-- vim.api.nvim_create_autocmd({ "BufWritePre", "InsertLeave" }, {
		-- 	buffer = 0,
		-- 	callback = indent_unindented_bullets,
		-- })
		-- Normal mode mappings
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("n", "$", "g$", { buffer = true })
		vim.keymap.set("n", "0", "g0", { buffer = true })
		-- Visual mode mappings
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
		vim.keymap.set("v", "$", "g$", { buffer = true })
		vim.keymap.set("v", "0", "g0", { buffer = true })
	end,
})
