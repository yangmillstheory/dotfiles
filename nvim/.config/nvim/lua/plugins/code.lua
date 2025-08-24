local keymap = require("utils").keymap

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		-- Resources (#<name>) - Add specific content (files, git diffs, URLs) to your prompt
		-- Tools (@<name>) - Give LLM access to functions it can call with your approval
		-- Sticky Prompts (> <text>) - Persist context across single chat session
		-- Models ($<model>) - Specify which AI model to use for the chat
		-- Prompts (/PromptName) - Use predefined prompt templates for common tasks
		keys = {
			{ "<leader>cc", ":CopilotChat<cr>", mode = "n", desc = "CopilotChat: Open chat" },
			{ "<leader>ce", ":CopilotChatExplain<cr>", mode = "v", desc = "CopilotChat: Explain selection" },
			{ "<leader>cr", ":CopilotChatReview<cr>", mode = "v", desc = "CopilotChat: Review selection" },
			{ "<leader>cf", ":CopilotChatFix<cr>", mode = "v", desc = "CopilotChat: Fix selection" },
			{ "<leader>cd", ":CopilotChatDocs<cr>", mode = "v", desc = "CopilotChat: Generate docs for selection" },
			{ "<leader>co", ":CopilotChatOptimize<cr>", mode = "v", desc = "CopilotChat: Optimize selection" },
			{ "<leader>ct", ":CopilotChatTests<cr>", mode = "v", desc = "CopilotChat: Generate tests for selection" },
			{ "<leader>cm", ":CopilotChatCommit<cr>", mode = "n", desc = "CopilotChat: Generate commit message" },
		},
		config = function()
			require("CopilotChat").setup()
		end,
	},
	{
		"github/copilot.vim",
		config = function()
			-- To conserve API usage.
			vim.g.copilot_enabled = false
			vim.g.copilot_no_tab_map = true
			keymap(
				"i",
				"<S-Tab>",
				'copilot#Accept("\\<S-Tab>")',
				{ expr = true, replace_keycodes = false, desc = "Copilot: Accept suggestion with Shift-Tab" }
			)
			keymap("i", "<c-c>w", "<Plug>(copilot-accept-word)", { desc = "Copilot: Accept next word" })
			keymap("i", "<c-c>l", "<Plug>(copilot-accept-line)", { desc = "Copilot: Accept next line" })
			keymap("i", "<c-c>?", "<Plug>(copilot-suggest)", { desc = "Copilot: Show suggestions" })
			keymap("i", "<c-c>j", "<Plug>(copilot-previous)", { desc = "Copilot: Previous suggestion" })
			keymap("i", "<c-c>k", "<Plug>(copilot-next)", { desc = "Copilot: Next suggestion" })
			keymap("i", "<c-c>x", "<Plug>(copilot-dismiss)", { desc = "Copilot: Dismiss suggestion" })
			keymap("n", "<c-c>p", ":Copilot panel<CR>", { desc = "Copilot: Open panel" })
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
