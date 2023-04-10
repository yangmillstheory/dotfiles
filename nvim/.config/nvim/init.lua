local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('settings')
require('keybinds')
require('plugins')
require('autocmd')
require('lsp')

vim.cmd.colorscheme('kanagawa')
vim.api.nvim_create_autocmd('VimEnter', {command='source /usr/share/vim/google/google.vim'})
