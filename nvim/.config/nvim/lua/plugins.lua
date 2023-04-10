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
  {'akinsho/bufferline.nvim', version = "v3.*", dependencies = 'nvim-tree/nvim-web-devicons'},
  'chentoast/marks.nvim',
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end
  },
  'ellisonleao/gruvbox.nvim',
  'folke/tokyonight.nvim',
  { 'junegunn/fzf', build = ':call fzf#install()' },
  { 'junegunn/fzf.vim', init = function() require('fzf-vim') end },
  'kylechui/nvim-surround',
  'matze/vim-move',
  'mhinz/vim-startify',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  'RRethy/vim-illuminate',
  'tmux-plugins/vim-tmux',
  'tpope/vim-commentary',
  'tpope/vim-obsession',
  'tpope/vim-sleuth',
  'windwp/nvim-autopairs',
  'yangmillstheory/vim-snipe',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', dependencies  = { 'smartpde/tree-sitter-cpp-google' }, },

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
