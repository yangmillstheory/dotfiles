local keymap = require("utils").keymap

return {
	{
		"github/copilot.vim",
		config = function()
			-- Use <Tab> to accept copilot suggestions.
			vim.g.copilot_no_tab_map = false
			keymap("i", "<m-c>w", "<Plug>(copilot-accept-word)")
			keymap("i", "<m-c>l", "<Plug>(copilot-accept-line)")
			keymap("i", "<m-c>?", "<Plug>(copilot-suggest)")
			keymap("i", "<m-c>j", "<Plug>(copilot-previous)")
			keymap("i", "<m-c>k", "<Plug>(copilot-next)")
			keymap("i", "<m-c>x", "<Plug>(copilot-dismiss)")
			keymap("n", "<m-c>p", ":Copilot panel<CR>")
		end,
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
	"RRethy/vim-illuminate",
	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				diagnostics = { auto_close = true, auto_open = false },
			},
		},
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
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
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
}
