return {
	{
		"uga-rosa/cmp-dictionary",
		ft = "markdown",
		opts = {
			paths = { "/usr/share/dict/words" },
			exact_length = 3,
			first_case_insensitive = true,
			document = {
				enable = true,
				command = { "wn", "${label}", "-over" },
			},
		},
	},
	{
		"uga-rosa/utf8.nvim",
		ft = "markdown",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip", -- cmp source for LuaSnip
			{
				"L3MON4D3/LuaSnip",
				dependencies = {
					"rafamadriz/friendly-snippets", -- Optional: a collection of prebuilt snippets
				},
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{
				"L3MON4D3/LuaSnip",
				dependencies = {
					"rafamadriz/friendly-snippets",
				},
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			-- Configure CMP
			vim.opt.completeopt = "menu,menuone,noselect"
			-- Don't show matching
			vim.opt.shortmess:append({ c = true })
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.close(),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					-- ["<cr>"] = cmp.mapping.confirm({ select = true }),
					["<cr>"] = cmp.mapping({
						i = function(fallback)
							local entry = cmp.get_selected_entry()
							if not entry or entry.source.name ~= "nvim_lsp" then
								return fallback()
							end
							local kind = entry.completion_item.kind
							if
								kind ~= vim.lsp.protocol.CompletionItemKind.Function
								and kind ~= vim.lsp.protocol.CompletionItemKind.Method
							then
								return fallback()
							end
							local _, start_col = unpack(cmp.core.get_cursor())
							local end_col = start_col + vim.fn.strwidth(entry.completion_item.label)
							local char_after = vim.api.nvim_get_current_line():sub(end_col, end_col)
							if char_after == "(" or char_after == ")" or char_after == '"' or char_after == "'" then
								return cmp.confirm({ select = false })
							end
							cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert })
							vim.api.nvim_feedkeys("()", "n", true)
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<Left>", true, true, true),
								"n",
								false
							)
						end,
						s = cmp.mapping.confirm({ select = true }),
						c = cmp.mapping.confirm({ select = true }),
					}),

					-- Pared down version of https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
					--
					-- I don't want completion to affect snippet completion.
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "path" },
					{ name = "luasnip" },
					{ name = "emoji" },
					{ name = "buffer", keyword_length = 3 },
				},

				formatting = {
					format = function(entry, vim_item)
						local menu_labels = {
							buffer = "[Buffer]",
							nvim_lua = "[Lua]",
							nvim_lsp = "[LSP]",
							emoji = "[Emoji]",
							path = "[Path]",
							luasnip = "[LuaSnip]", -- Changed from '[snip]' for clarity/consistency
						}
						vim_item.menu = menu_labels[entry.source.name] or ("[" .. entry.source.name .. "]")
						return vim_item
					end,
				},
			})
			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				-- See https://github.com/hrsh7th/cmp-cmdline/issues/108#issuecomment-2052449375
				mapping = cmp.mapping.preset.cmdline({
					["<C-n>"] = { c = cmp.mapping.select_next_item() },
					["<C-p>"] = { c = cmp.mapping.select_prev_item() },
				}),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			cmp.setup.filetype("markdown", {
				sources = {
					{ name = "dictionary", keyword_length = 3 },
					{ name = "emoji" },
					{ name = "buffer", keyword_length = 3 },
				},
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "zsh",
				callback = function()
					cmp.setup.buffer({ sources = { { name = "zsh" } } })
				end,
			})
		end,
	},
}
