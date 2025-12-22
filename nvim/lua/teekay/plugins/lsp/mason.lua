return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Setup capabilities with offset encoding
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.general = capabilities.general or {}
		capabilities.general.positionEncodings = { "utf-16", "utf-8" }

		mason_lspconfig.setup({
			-- list of servers for mason to install
			automatic_installation = true,
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
			},
			handlers = {
				-- default handler for installed servers
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						offset_encoding = "utf-16",
					})
				end,
				["svelte"] = function()
					-- configure svelte server
					require("lspconfig")["svelte"].setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,
				["graphql"] = function()
					-- configure graphql language server
					require("lspconfig")["graphql"].setup({
						capabilities = capabilities,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,
				["emmet_ls"] = function()
					-- configure emmet language server
					require("lspconfig")["emmet_ls"].setup({
						capabilities = capabilities,
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,
				["lua_ls"] = function()
					-- configure lua server (with special settings)
					require("lspconfig")["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
				["pyright"] = function()
					require("lspconfig")["pyright"].setup({
						capabilities = capabilities,
						settings = {
							python = {
								-- Path to the virtual environment
								venvPath = ".venv",
								pythonPath = ".venv/bin/python",

								analysis = {
									-- Enable searching in workspace
									autoSearchPaths = true,

									-- Use library code for types (enables better import resolution)
									useLibraryCodeForTypes = true,

									-- Check imports across the whole workspace
									diagnosticMode = "workspace",

									-- Extra paths for module resolution
									extraPaths = {
										".", -- Add current directory to path
										"src", -- Common source directory
									},

									-- Type checking settings
									typeCheckingMode = "basic", -- Set to "off", "basic", or "strict" as needed

									-- Import resolution settings
									diagnosticSeverityOverrides = {
										-- Make import resolution issues visible
										reportMissingImports = "error",
										reportMissingModuleSource = "error",
										reportMissingTypeStubs = "none",
									},
								},
							},
						},
						before_init = function(_, config)
							local venv = vim.fn.expand(".venv")
							if vim.fn.isdirectory(venv) == 1 then
								local python_path = venv .. "/bin/python"
								config.settings.python.pythonPath = python_path

								-- Add root directory of the project to help with local imports
								local root_dir = vim.fn.getcwd()
								table.insert(config.settings.python.analysis.extraPaths, root_dir)
							end
						end,
					})
				end,
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"autoflake", -- python - remove unused imports
				-- "pylint",
				"eslint_d",
			},
		})
	end,
}
