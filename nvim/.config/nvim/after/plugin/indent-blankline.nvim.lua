vim.opt.list = true
vim.g.indent_blankline_filetype = { "cpp", "python", "lua", }

require("ibl").setup {
  exclude = {
    filetypes = {
      -- breaks tree-sitter highlighting
      'html',
      -- defaults
      'lspinfo',
      'packer',
      'checkhealth',
      'help',
      'man',
      'gitcommit',
    }
  }
}
