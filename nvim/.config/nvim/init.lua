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
require('jp')

vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')

require('autocmd')
require('lsp')
require('cmpl')
