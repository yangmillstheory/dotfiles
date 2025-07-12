return {
  {
    'uga-rosa/cmp-dictionary',
    opts = {
      paths = { "/usr/share/dict/words" },
      exact_length = 2,
      first_case_insensitive = true,
      document = {
        enable = true,
        command = { "wn", "${label}", "-over" },
      }
    },
  },
  {
    'uga-rosa/utf8.nvim',
    config = function()
      require('jp')
    end
  },
  -- TODO: Check all this
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-emoji',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'hrsh7th/cmp-path',
  {
    'hrsh7th/nvim-cmp',
    config = function()
      -- Configure CMP
      vim.opt.completeopt = 'menu,menuone,noselect'

      -- Don't show matching
      vim.opt.shortmess:append('c')

      local cmp = require('cmp')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-u>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-y>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          -- Don't understand this setting; doesn't appear to work when using
          -- cmp.SelectBehavior.Select above.
          ['<C-l>'] = cmp.mapping.confirm({ select = true }),

          -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#vim-vsnip
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends an already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
        }),

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'path' },
          { name = 'vim_vsnip' },
          { name = 'emoji' },
          { name = 'buffer', keyword_length = 3 },
        },

        sorting = {
          comparators = {}, -- We stop all sorting to let the lsp do the sorting
        },

        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },

        formatting = {
          format = function(entry, vim_item)
            local menu_labels = {
              buffer = '[Buffer]',
              nvim_lua = '[Lua]',
              nvim_lsp = '[LSP]',
              emoji = '[Emoji]',
              path = '[Path]',
              vim_vsnip = '[Snippet]', -- Changed from '[snip]' for clarity/consistency
            }
            vim_item.menu = menu_labels[entry.source.name] or ('[' .. entry.source.name .. ']')
            return vim_item
          end
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        -- See https://github.com/hrsh7th/cmp-cmdline/issues/108#issuecomment-193083214.
        mapping = cmp.mapping.preset.cmdline({
          ['<C-n>'] = { c = false },
          ['<C-p>'] = { c = false },
        }),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

      cmp.setup.filetype('markdown', {
        sources = {
          {
            name = "dictionary",
            keyword_length = 2,
          },
          { name = 'emoji' },
          { name = 'buffer', keyword_length = 3 },
        }
      })

      vim.cmd([[
        augroup CmpZsh
          au!
          autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = 'zsh' }, } }
        augroup END
      ]])
    end
  },
}
