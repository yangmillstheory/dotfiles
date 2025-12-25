return {
	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				diagnostics = { auto_close = true, auto_open = false },
			},
		},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle focus=false<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xb",
				"<cmd>Trouble diagnostics toggle filter.buf=0 focus=false<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=false win.position=right win.size.width=0.25<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
		},
	},
	{
		"ruifm/gitlinker.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local gitlinker = require("gitlinker")
			gitlinker.setup({
				opts = {
					print_url = true,
				},
				mappings = "<leader>gy",
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					-- breaks tree-sitter highlighting
					"html",
					-- defaults
					"lspinfo",
					"packer",
					"checkhealth",
					"help",
					"man",
					"gitcommit",
				},
			},
		},
		ft = { "c", "cpp", "python", "go", "lua" },
		init = function()
			vim.g.indent_blankline_filetype = { "cpp", "python", "lua", "typescript", "javascript", "go" }
		end,
	},
	{ "RRethy/vim-illuminate", event = "VeryLazy" },
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		priority = 1001,
		config = function()
			local configs = require("nvim-treesitter.configs")
			--- @diagnostic disable: missing-fields
			--- See https://github.com/nvim-treesitter/nvim-treesitter/issues/5297.
			configs.setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"javascript",
					"typescript",
					"python",
					"go",
					"terraform",
					"hcl",

					"markdown",
					"markdown_inline",
				},

				ft_to_parser = {
					tf = "hcl",
					terraform = "hcl",
				},

				ignore_install = {},
				auto_install = false,
				sync_install = false,
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},
			})
			---@diagnostic enable: missing-fields
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false
			-- Open all folds by default
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
		end,
	},
	--luacheck: globals Difft
	{
		"ahkohd/difft.nvim",
		keys = {
			{
				"<leader>d",
				function()
					if Difft.is_visible() then
						Difft.hide()
					else
						Difft.diff()
					end
				end,
				desc = "Toggle Difft",
			},
		},
		config = function()
			require("difft").setup({
				layout = "float",
				command = "GIT_EXTERNAL_DIFF='difft --color=always' git diff",
				window = {
					number = false,
					relativenumber = false,
					border = "rounded",
				},
			})
		end,
	},
}
