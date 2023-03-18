-- CiderLSP

-- 1. Configure CiderLSP
-- Set desired filetypes from go/ciderlsp#supported
-- To list all filetype names, see https://vi.stackexchange.com/a/14990
local nvim_lsp = require('lspconfig')
local configs = require('lspconfig.configs')
configs.ciderlsp = {
  default_config = {
    cmd = { '/google/bin/releases/cider/ciderlsp/ciderlsp', '--tooltag=nvim-cmp', '--noforward_sync_responses' },
    filetypes = { 'c', 'cpp', 'java', 'kotlin', 'objc', 'proto', 'textproto', 'go', 'python', 'bzl' },
    root_dir = nvim_lsp.util.root_pattern('BUILD'),
    settings = {},
  },
}
configs.lua_ls = {
  default_config = {
    cmd = { '/usr/local/google/home/victoralvarez/code/lua-ls/bin/lua-language-server' },
    filetypes = { 'lua' },
    root_dir = nvim_lsp.util.root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git"),
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
}
-- 2. Configure CMP
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
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-m>'] = cmp.mapping.confirm({ select = true }),
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
        nvim_lsp = '[CiderLSP]',
        nvim_lua = '[API]',
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
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

vim.cmd([[
  augroup CmpZsh
    au!
    autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = 'zsh' }, } }
  augroup END
]])

-- 3. Set up CiderLSP
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  if vim.lsp.formatexpr then -- Neovim v0.6.0+ only.
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr')
  end
  if vim.lsp.tagfunc then
    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
  end

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

  vim.api.nvim_command('augroup LSP')
  vim.api.nvim_command('autocmd!')
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_command('autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()')
    vim.api.nvim_command('autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()')
    vim.api.nvim_command('autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()')
  end
  vim.api.nvim_command('augroup END')
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities())

nvim_lsp.ciderlsp.setup({ capabilities = capabilities, on_attach = on_attach })
nvim_lsp.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  autostart = true,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
