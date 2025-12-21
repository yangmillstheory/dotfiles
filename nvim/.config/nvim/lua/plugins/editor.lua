return {
	{
		"axkirillov/hbac.nvim",
		config = true,
	},
	{
		"christoomey/vim-tmux-navigator",
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
			vim.g.tmux_navigator_disable_when_zoomed = 1
		end,
		config = function()
			local utils = require("utils")

			utils.keymap("n", "<A-h>", ":TmuxNavigateLeft<cr>", { desc = "Navigate left (tmux)" })
			utils.keymap("n", "<A-j>", ":TmuxNavigateDown<cr>", { desc = "Navigate down (tmux)" })
			utils.keymap("n", "<A-k>", ":TmuxNavigateUp<cr>", { desc = "Navigate up (tmux)" })
			utils.keymap("n", "<A-l>", ":TmuxNavigateRight<cr>", { desc = "Navigate right (tmux)" })
		end,
	},
	{
		"kylechui/nvim-surround",
		config = true,
	},
	{
		"matze/vim-move",
		init = function()
			vim.g.move_map_keys = 0
		end,
		config = function()
			local utils = require("utils")

			utils.keymap("v", "<A-S-j>", "<Plug>MoveBlockDown", { desc = "Move block down (visual)" })
			utils.keymap("n", "<A-S-h>", "<Plug>MoveCharLeft", { desc = "Move character left (normal)" })
			utils.keymap("v", "<A-S-h>", "<Plug>MoveBlockLeft", { desc = "Move block left (visual)" })
			utils.keymap("n", "<A-S-j>", "<Plug>MoveLineDown", { desc = "Move line down (normal)" })
			utils.keymap("n", "<A-S-k>", "<Plug>MoveLineUp", { desc = "Move line up (normal)" })
			utils.keymap("v", "<A-S-k>", "<Plug>MoveBlockUp", { desc = "Move block up (visual)" })
			utils.keymap("v", "<A-S-l>", "<Plug>MoveBlockRight", { desc = "Move block right (visual)" })
			utils.keymap("n", "<A-S-l>", "<Plug>MoveCharRight", { desc = "Move character right (normal)" })
		end,
	},
	"tmux-plugins/vim-tmux",
	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				"<leader>B",
				function()
					require("snipe").open_buffer_menu()
				end,
				desc = "Open Snipe buffer menu",
			},
		},
		opts = {
			ui = {
				open_win_override = {
					title = "Buffers",
					border = "rounded",
				},
				position = "center",
				preselect_current = true,
				persist_tags = false,
			},
			navigate = {
				-- Make sure tags don't conflict with these. For
				-- example, never assign "j" and "k" tags.
				-- These are purposely similar to Telescope bindings.
				open_split = "<c-x>",
				open_vsplit = "<c-v>",
				close_buffer = "X",
				change_tag = "*",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.1.9",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		opts = function()
			return {
				defaults = {
					file_ignore_patterns = { ".git/" },
					vimgrep_arguments = {
						"rg",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob",
						"!.git/",
						"--glob",
						"!.venv/",
						"--glob",
						"!go.mod",
						"--glob",
						"!go.sum",
					},
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob",
						"!.git/",
						"--glob",
						"!.venv/",
					},
				},
				extensions = {
					fzf = {},
				},
				pickers = {
					git_commits = {
						layout_strategy = "vertical",
						layout_config = {
							prompt_position = "bottom",
							preview_height = 0.70,
							height = 0.95,
							width = 0.95,
						},
					},
				},
			}
		end,
		keys = {
			{
				"<leader>t",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "Telescope find files",
			},
			{
				"<leader>f",
				function()
					require("telescope").extensions.live_grep_args.live_grep_args()
				end,
				desc = "Telescope live grep",
			},
			{
				"<leader>b",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Telescope buffers",
			},
			{
				"<leader>C",
				function()
					require("telescope.builtin").commands()
				end,
				desc = "Telescope commands",
			},
			{
				"<leader>?",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Telescope help_tags",
			},
			{
				"<leader>!",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Telescope diagnostics",
			},
			{
				"<leader>m",
				function()
					require("telescope.builtin").marks()
				end,
				desc = "Telescope marks",
			},
			{
				"<leader>ld",
				function()
					require("telescope.builtin").lsp_definitions()
				end,
				desc = "Telescope LSP defs",
			},
			{
				"<leader>lr",
				function()
					require("telescope.builtin").lsp_references()
				end,
				desc = "Telescope LSP refs",
			},
			{
				"<leader>li",
				function()
					require("telescope.builtin").lsp_implementations()
				end,
				desc = "Telescope LSP impl",
			},
			{
				"<leader>lt",
				function()
					require("telescope.builtin").lsp_type_definitions()
				end,
				desc = "Telescope LSP typedef",
			},
			{
				"<leader>ls",
				function()
					require("telescope.builtin").lsp_document_symbols()
				end,
				desc = "Telescope LSP buf symbols",
			},
			{
				"<leader>r",
				function()
					require("telescope.builtin").command_history()
				end,
				desc = "Telescope command history",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").search_history()
				end,
				desc = "Telescope search history",
			},
			{
				"<leader>G",
				function()
					require("telescope.builtin").git_commits()
				end,
				desc = "Telescope git commits",
			},
			{
				"<leader>.",
				function()
					require("telescope.builtin").find_files({
						hidden = true,
						cwd = vim.fn.expand("~/code/dotfiles"),
					})
				end,
				desc = "Telescope edit dotfiles",
			},
		},
		config = function(_, opts)
			local lga_actions = require("telescope-live-grep-args.actions")

			opts.extensions.live_grep_args = {
				auto_quoting = true,
				mappings = {
					i = {
						["<C-k>"] = lga_actions.quote_prompt(),
						["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						["<C-t>"] = lga_actions.quote_prompt({ postfix = " --type " }),
					},
				},
			}

			local telescope = require("telescope")
			telescope.setup(opts)
			-- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-fzf-nativenvim
			telescope.load_extension("fzf")
			-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim?tab=readme-ov-file#grep-argument-examples
			telescope.load_extension("live_grep_args")
		end,
	},
	{ "windwp/nvim-autopairs", config = true },
	{
		"yangmillstheory/vim-snipe",
		config = function()
			local utils = require("utils")
			-- Because I don't want the annoying prompt messages
			-- due to plugin output, which will happen because I set
			-- cmdheight=0 elsewhere.
			vim.g.snipe_silent = true
			-- flash.nvim is better for these keymaps.
			-- utils.keymap('', 'f', '<Plug>(snipe-F)')
			-- utils.keymap('', 'f', '<Plug>(snipe-f)')
			-- utils.keymap('', 'T', '<Plug>(snipe-T)')
			-- utils.keymap('', 't', '<Plug>(snipe-t)')
			utils.keymap("", "<leader><leader>w", "<Plug>(snipe-w)", { desc = "Jump forward to word start" })
			utils.keymap("", "<leader><leader>W", "<Plug>(snipe-W)", { desc = "Jump back to word start" })
			utils.keymap("", "<leader><leader>e", "<Plug>(snipe-e)", { desc = "Jump forward to word end" })
			utils.keymap("", "<leader><leader>E", "<Plug>(snipe-E)", { desc = "Jump back to word end" })
			utils.keymap("", "<leader><leader>b", "<Plug>(snipe-b)", { desc = "Jump forward to word backward" })
			utils.keymap("", "<leader><leader>B", "<Plug>(snipe-B)", { desc = "Jump back to word backward" })
			utils.keymap("", "<leader><leader>ge", "<Plug>(snipe-ge)", { desc = "Jump forward to end of WORD" })
			utils.keymap("", "<leader><leader>gE", "<Plug>(snipe-gE)", { desc = "Jump back to end of WORD" })
			-- Swap.
			utils.keymap("n", "<leader><leader>]", "<Plug>(snipe-f-xp)", { desc = "Swap with next character" })
			utils.keymap("n", "<leader><leader>[", "<Plug>(snipe-F-xp)", { desc = "Swap with previous character" })
			-- Cut.
			utils.keymap("n", "<leader><leader>x", "<Plug>(snipe-f-x)", { desc = "Cut forward" })
			utils.keymap("n", "<leader><leader>X", "<Plug>(snipe-F-x)", { desc = "Cut back" })
			-- Replace.
			utils.keymap("n", "<leader><leader>r", "<Plug>(snipe-f-r)", { desc = "Replace forward" })
			utils.keymap("n", "<leader><leader>R", "<Plug>(snipe-F-r)", { desc = "Replace back" })
			-- Insert.
			utils.keymap("n", "<leader><leader>i", "<Plug>(snipe-f-i)", { desc = "Insert forward" })
			utils.keymap("n", "<leader><leader>I", "<Plug>(snipe-F-i)", { desc = "Insert back" })
			-- Append.
			utils.keymap("n", "<leader><leader>a", "<Plug>(snipe-f-a)", { desc = "Append forward" })
			utils.keymap("n", "<leader><leader>A", "<Plug>(snipe-F-a)", { desc = "Append back" })
		end,
	},
	"tpope/vim-obsession",
	{
		-- vim-snipe doesn't give me jump labels on search.
		"folke/flash.nvim",
		opts = {
			modes = {
				char = {
					jump_labels = true,
					autohide = true,
				},
			},
		},
		keys = {
			"f",
			"F",
			"t",
			"T",
			{
				"<c-f>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{ "folke/lazydev.nvim", ft = "lua", opts = {} },
}
