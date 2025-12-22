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
			-- vim.o.background = "dark"
			-- vim.cmd.colorscheme("kanagawa")
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("gruvbox").setup({
				transparent_mode = true,
				dim_inactive = false,
				contrast = "hard",
			})
			vim.o.background = "dark"
			vim.cmd.colorscheme("gruvbox")
			vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
			require("notify").setup({
				background_colour = "NotifyBackground",
				merge_duplicates = true,
			})
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
		event = "VimEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"yavorski/lualine-macro-recording.nvim",
		},
		opts = function(_, opts)
			opts.options = opts.options or {}
			opts.options.theme = "auto"

			opts.sections = opts.sections or {}
			opts.sections.lualine_a = { "mode" }
			opts.sections.lualine_b = {
				"ObsessionStatus",
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
				"branch",
				"selectioncount",
				"lsp_status",
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
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		priority = 10, -- Low priority to catch other plugins' keybindings
		config = function()
			require("tiny-glimmer").setup({
				overwrite = {
					search = {
						enabled = true,
						default_animation = "pulse",
						next_mapping = "n",
						prev_mapping = "N",
					},
					undo = {
						enabled = true,
						default_animation = {
							name = "fade",
							settings = {
								from_color = "DiffDelete",
								max_duration = 500,
								min_duration = 500,
							},
						},
						undo_mapping = "u",
					},
					redo = {
						enabled = true,
						default_animation = {
							name = "fade",
							settings = {
								from_color = "DiffAdd",
								max_duration = 500,
								min_duration = 500,
							},
						},
						redo_mapping = "U",
					},
				},
			})
		end,
	},
}
