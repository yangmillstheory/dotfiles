local keymap = require("utils").keymap

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
		"CopilotC-Nvim/CopilotChat.nvim",
		-- Resources (#<name>) - Add specific content (files, git diffs, URLs) to your prompt
		-- Tools (@<name>) - Give LLM access to functions it can call with your approval
		-- Sticky Prompts (> <text>) - Persist context across single chat session
		-- Models ($<model>) - Specify which AI model to use for the chat
		-- Prompts (/PromptName) - Use predefined prompt templates for common tasks
		keys = {
			{ "<leader>cc", ":CopilotChatToggle<cr>", mode = "n", desc = "CopilotChat: Open chat" },
			{ "<leader>ce", ":CopilotChatExplain<cr>", mode = "v", desc = "CopilotChat: Explain selection" },
			{ "<leader>cr", ":CopilotChatReview<cr>", mode = "v", desc = "CopilotChat: Review selection" },
			{ "<leader>cf", ":CopilotChatFix<cr>", mode = "v", desc = "CopilotChat: Fix selection" },
			{ "<leader>cd", ":CopilotChatDocs<cr>", mode = "v", desc = "CopilotChat: Generate docs for selection" },
			{ "<leader>co", ":CopilotChatOptimize<cr>", mode = "v", desc = "CopilotChat: Optimize selection" },
			{ "<leader>ct", ":CopilotChatTests<cr>", mode = "v", desc = "CopilotChat: Generate tests for selection" },
			{ "<leader>cm", ":CopilotChatCommit<cr>", mode = "n", desc = "CopilotChat: Generate commit message" },
		},
		config = function()
			require("CopilotChat").setup({
				prompts = {
					-- The out-of-the-box version uses #buffer which makes no sense.
					Commit = {
						prompt = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block. If user has COMMIT_EDITMSG opened, generate replacement block for whole buffer.",
						resources = {
							"gitdiff:staged",
						},
					},
				},
			})
		end,
	},
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_enabled = true
			vim.g.copilot_no_tab_map = true
			keymap(
				"i",
				"<c-a><c-a>",
				'copilot#Accept("\\<c-a><c-a>")',
				{ expr = true, replace_keycodes = false, desc = "Copilot: Accept suggestion with <c-a><c-a>" }
			)
			keymap("i", "<c-a>w", "<Plug>(copilot-accept-word)", { desc = "Copilot: Accept next word" })
			keymap("i", "<c-a>l", "<Plug>(copilot-accept-line)", { desc = "Copilot: Accept next line" })
			keymap("i", "<c-a>?", "<Plug>(copilot-suggest)", { desc = "Copilot: Show suggestions" })
			keymap("i", "<c-a>j", "<Plug>(copilot-previous)", { desc = "Copilot: Previous suggestion" })
			keymap("i", "<c-a>k", "<Plug>(copilot-next)", { desc = "Copilot: Next suggestion" })
			keymap("i", "<c-a>x", "<Plug>(copilot-dismiss)", { desc = "Copilot: Dismiss suggestion" })
			keymap("n", "<c-a>p", ":Copilot panel<CR>", { desc = "Copilot: Open panel" })
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
				keymaps = {
					-- Next file change
					next = "<Down>",
					-- Previous file change
					prev = "<Up>",
					-- Close diff window (float only)
					close = "q",
					-- Refresh diff
					refresh = "r",
					-- First file change
					first = "gg",
					-- Last file change
					last = "G",
				},
			})
		end,
	},
}
