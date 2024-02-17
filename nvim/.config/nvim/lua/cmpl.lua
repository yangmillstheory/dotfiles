-- Configure CMP
vim.opt.completeopt = 'menu,menuone,noselect'

-- Don't show matching
vim.opt.shortmess:append('c')

local lspkind = require('lspkind')
lspkind.init()

local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['C-n'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- Don't understand this setting; doesn't appear to work when using
    -- cmp.SelectBehavior.Select above.
    ['<C-Enter>'] = cmp.mapping.confirm({ select = true }),
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
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 40, -- half max width
      menu = {
        buffer = '[buffer]',
        nvim_lua = '[Lua]',
        nvim_lsp = '[LSP]',
        emoji = '[emoji]',
        path = '[path]',
        vim_vsnip = '[snip]',
      },
    }),
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

