require("lazy").setup({
  defaults = {
    lazy = true
  },
  { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end
  },
  {
    'axkirillov/hbac.nvim',
    config = true,
  },
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
      'csv',
      'tsv',
      'csv_semicolon',
      'csv_whitespace',
      'csv_pipe',
      'rfc_csv',
      'rfc_semicolon'
    },
    cmd = {
      'RainbowDelim',
      'RainbowDelimSimple',
      'RainbowDelimQuoted',
      'RainbowMultiDelim'
    }
  },
  'folke/trouble.nvim',
  { 'junegunn/fzf', build = ':call fzf#install()' },
  { 'junegunn/fzf.vim', init = function() require('fzf-vim') end },
  'kylechui/nvim-surround',
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    ft = { "c", "cpp", "python", "go"},
  },
  'matze/vim-move',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  'rebelot/kanagawa.nvim',
  {
    'r-cha/encourage.nvim',
    config = true
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  'tmux-plugins/vim-tmux',
  'tpope/vim-obsession',
  'windwp/nvim-autopairs',
  'yangmillstheory/vim-snipe',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'uga-rosa/cmp-dictionary',
  'uga-rosa/utf8.nvim',
  'RRethy/vim-illuminate',

  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-emoji',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'hrsh7th/cmp-path',
  'hrsh7th/nvim-cmp',
  'neovim/nvim-lspconfig',
  'onsails/lspkind.nvim',
  { 'OXY2DEV/markview.nvim', lazy = false },
})
