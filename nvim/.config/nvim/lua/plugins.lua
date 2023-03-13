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

require("lazy").setup({
  'christoomey/vim-tmux-navigator',
  {
    'edkolev/tmuxline.vim',
    cmd = 'Tmuxline'
  },
  'nvim-lualine/lualine.nvim',
  'windwp/nvim-autopairs',
  {
    'junegunn/fzf.vim',
    dependencies = {
      { 'junegunn/fzf', build = ':call fzf#install()' },
    },
    init = function() require('fzf-vim') end
  },
  'matze/vim-move',
  'ellisonleao/gruvbox.nvim',
  'tmux-plugins/vim-tmux',
  {
    'simeji/winresizer',
    init = function()
      vim.g.winresizer_start_key = '<leader>r'
      -- make it like i3
      vim.g.winresizer_keycode_up = 106
      vim.g.winresizer_keycode_down = 107
    end
  },
  'tpope/vim-commentary',
  'tpope/vim-surround',
  'tpope/vim-obsession',
  'yangmillstheory/vim-snipe',

  -- CiderLSP
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'neovim/nvim-lspconfig',
  'onsails/lspkind.nvim',

  -- Diagnostics
  { 
    'folke/trouble.nvim', dependencies = { 'kyazdani42/nvim-web-devicons' } 
  },
})
