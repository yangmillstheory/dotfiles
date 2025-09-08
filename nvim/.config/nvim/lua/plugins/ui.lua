local keymap = require("utils").keymap
-- Plugins that make nvim prettier.
return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline = require("bufferline")
			bufferline.setup({
				options = {
					-- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
					separator_style = "slope",
					indicator = {
						style = "none",
					},
				},
			})
			keymap("n", "bq", ":bw<CR>", { desc = "Close buffer" })
			keymap("n", "bj", ":BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
			keymap("n", "bk", ":BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
			keymap("n", "bg", ":BufferLinePick<CR>", { desc = "Pick buffer from bufferline" })
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("kanagawa").setup({
				transparent = false,
				dimInactive = true,
				theme = "wave",
			})
			vim.o.background = "dark"
			vim.cmd.colorscheme("kanagawa")
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("gruvbox").setup({
				transparent_mode = false,
				dim_inactive = true,
				contrast = "hard",
			})
			-- vim.o.background = 'dark'
			-- vim.cmd.colorscheme("gruvbox")
		end,
	},
	{
		"cameron-wags/rainbow_csv.nvim",
		config = true,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"folke/trouble.nvim",
			"yavorski/lualine-macro-recording.nvim",
		},
		opts = function(_, opts)
			local trouble = require("trouble")

			opts.options = opts.options or {}
			opts.options.theme = "auto"

			opts.sections = opts.sections or {}
			opts.sections.lualine_a = { "mode" }
			opts.sections.lualine_b = {
				"ObsessionStatus",
				"diff",
				"diagnostics",
				"macro_recording",
			}
			opts.sections.lualine_c = {
				{
					"filename",
					path = 1,
					shorting_target = 20,
					symbols = {
						modified = "✗",
						readonly = "",
					},
				},
			}

			return opts
		end,
		lazy = false,
	},
	{
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "copilot-chat" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function()
			require("render-markdown").setup({
				completions = { lsp = { enabled = true } },
			})
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	-- lazy.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
			keymap("n", "<leader>nd", "<cmd>Noice dismiss<cr>", { desc = "Dismiss all Noice messages" })
			keymap("n", "<leader>nt", "<cmd>Noice dismiss<cr>", { desc = "Dismiss all Noice messages" })
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				height = 0.85,
			},
			plugins = {
				alacritty = {
					enabled = true,
					font = "14",
				},
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			preset = "modern",
		},
	},
}
