require("lazy").setup({
  defaults = {
    lazy = true
  },
  { 'akinsho/bufferline.nvim', version = "v3.*", dependencies = 'nvim-tree/nvim-web-devicons' },
  {
    'anuvyklack/fold-preview.nvim',
     dependencies = 'anuvyklack/keymap-amend.nvim',
  },
  'chentoast/marks.nvim',
  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end
  },
  'folke/trouble.nvim',
  { 'junegunn/fzf', build = ':call fzf#install()' },
  { 'junegunn/fzf.vim', init = function() require('fzf-vim') end },
  'kylechui/nvim-surround',
  { "lukas-reineke/indent-blankline.nvim", ft = { "cpp", "python", "proto", "gcl" } },
  'matze/vim-move',
  'mhinz/vim-startify',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  'rebelot/kanagawa.nvim',
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
