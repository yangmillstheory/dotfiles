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
  { 'akinsho/bufferline.nvim', tag = 'v3.*', requires = 'nvim-tree/nvim-web-devicons' },
  'chentoast/marks.nvim',
  'christoomey/vim-tmux-navigator',
  'Darazaki/indent-o-matic',
  'ellisonleao/gruvbox.nvim',
  { 'junegunn/fzf', build = ':call fzf#install()' },
  {
    'junegunn/fzf.vim',
    init = function() require('fzf-vim') end
  },
  'kylechui/nvim-surround',
  'matze/vim-move',
  'mkitt/tabline.vim',
  {

    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },
  {
    'simeji/winresizer',
    init = function()
      vim.g.winresizer_start_key = '<leader>r'
      -- make it like i3
      vim.g.winresizer_keycode_up = 106
      vim.g.winresizer_keycode_down = 107
    end
  },
  'RRethy/vim-illuminate',
  'tmux-plugins/vim-tmux',
  'tpope/vim-commentary',
  'tpope/vim-obsession',
  'windwp/nvim-autopairs',
  'yamatsum/nvim-cursorline',
  'yangmillstheory/vim-snipe',
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies  = { 'smartpde/tree-sitter-cpp-google' },
  },

  -- CiderLSP
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'neovim/nvim-lspconfig',
  'onsails/lspkind.nvim',
})
