--[[
These GLOBAL keymaps are created unconditionally when Nvim starts:
- "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
- "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
- "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
- "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
- "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
- CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
- "an" and "in" are mapped in Visual mode to outer and inner incremental
  selections, respectively, using |vim.lsp.buf.selection_range()|
]]
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/lazydev.nvim',
      ft = "lua",
      opts = {}
    },
    config = function()
      local nvim_lsp = require('lspconfig')

      nvim_lsp.ts_ls.setup({
        on_attach = function(client, _)
          -- optional: disable formatting if you use something like prettier
          client.server_capabilities.documentFormattingProvider = false
        end,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        cmd = { "typescript-language-server", "--stdio" },
      })

      nvim_lsp.pyright.setup{}
      nvim_lsp.lua_ls.setup{}
    end
  },
}
