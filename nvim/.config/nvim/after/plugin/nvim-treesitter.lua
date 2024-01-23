require('nvim-treesitter.configs').setup({
  ensure_installed = { 'cpp', 'lua', 'vim', 'go', 'python'},
  highlight = {
    enable = true,
  }
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
