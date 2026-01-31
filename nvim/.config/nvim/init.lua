if vim.g.vscode then
	require("teekay.core.options")
	require("teekay.core.keymaps")
else
	require("teekay.core")
	require("teekay.lazy")
end
