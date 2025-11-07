--[[
These GLOBAL keymaps are created unconditionally when Nvim starts:
- "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
- "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
- "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
- "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
- "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
- CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
- "an" and "in" are mapped in Visual mode to outer and inner incremental
  selections, respectively, using |vim.lsp.buf.selection_range()|
]]
return {
	{
		"mason-org/mason-lspconfig.nvim",
		cmd = { "Mason", "LspInstall" },
		opts = {
			ensure_installed = {
				-- If commented out, Mason will complain that these are not language servers. They're
				-- nonetheless installed with Mason, though, and I'm adding them here to record them.
				--
				-- Formatters
				-- "black",
				-- "prettier",
				-- "stylua",
				-- "yamlfmt",
				--
				-- Linters
				-- "luacheck",
				-- "kube-linter", -- Too annoying to set up with conditions on filepaths. Install via Homebrew.
				-- "vale",
				-- "terraform",
				-- "golangci-lint",
				"marksman",
				"gopls",
				"gh_actions_ls",
				"lua_ls",
				"pyright",
				"terraformls",
				"ts_ls",
				"yamlls",
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "neovim/nvim-lspconfig" },
		},
		config = function(opts)
			local common_opts = {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			}
			vim.lsp.config("*", common_opts)
			vim.lsp.config("marksman", {
				filetypes = { "markdown", "copilot-chat" },
			})
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemas = {
							["kubernetes"] = {
								"**/kubernetes/**/*.{yaml,yml}",
								"**/k8s/**/*.{yaml,yml}",
								"**/manifests/**/*.{yaml,yml}",
							},
							["https://json.schemastore.org/kustomization.json"] = { "kustomization" },
							["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yaml,yml}",
							["https://json.schemastore.org/github-action.json"] = ".github/actions/*/action.{yaml,yml}",
							["https://json.schemastore.org/chart"] = "**/Chart.{yaml,yml}",
						},
					},
				},
			})
			require("mason").setup()
			require("mason-lspconfig").setup({ ensure_installed = opts.ensure_installed })
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua", lsp_format = "never" },
				python = function(bufnr)
					if require("conform").get_formatter_info("ruff_format", bufnr).available then
						return { "ruff_format" }
					else
						return { "black" }
					end
				end,
				yaml = { "yamlfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				tf = { "terraform_fmt" },
				terraform = { "terraform_fmt" },
				go = { "goimports" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				go = { "golangcilint" },
				lua = { "luacheck" },
				terraform = { "tflint" },
				text = { "vale" },
			}
			lint.linters.luacheck.args = { "--globals", "vim" }
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
