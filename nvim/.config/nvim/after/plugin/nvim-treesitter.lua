require('tree-sitter-cpp-google').setup()
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'cpp', 'lua', 'vim', 'go', 'python'},
  highlight = { enable = true }
})
