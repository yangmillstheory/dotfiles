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
