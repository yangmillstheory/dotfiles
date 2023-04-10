require('settings')
require('keybinds')
require('plugins')
require('autocmd')
require('lsp')

vim.cmd.colorscheme('kanagawa')
vim.api.nvim_create_autocmd('VimEnter', {command='source /usr/share/vim/google/google.vim'})
