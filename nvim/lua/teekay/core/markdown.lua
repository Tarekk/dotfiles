vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		-- Normal mode mappings
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("n", "h", "gh", { buffer = true })
		vim.keymap.set("n", "l", "gl", { buffer = true })
		vim.keymap.set("n", "$", "g$", { buffer = true })
		vim.keymap.set("n", "0", "g0", { buffer = true })
		-- Visual mode mappings
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
		vim.keymap.set("v", "h", "gh", { buffer = true })
		vim.keymap.set("v", "l", "gl", { buffer = true })
		vim.keymap.set("v", "$", "g$", { buffer = true })
		vim.keymap.set("v", "0", "g0", { buffer = true })
	end,
})
