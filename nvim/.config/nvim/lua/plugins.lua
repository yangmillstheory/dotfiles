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
  {
    'folke/zen-mode.nvim',
    opts = {
      window = {
        height = 0.8,
        options = { relativenumber = false, number = false }
      }
    }
  },
  { 'junegunn/fzf', build = ':call fzf#install()' },
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
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
          "nvim-telescope/telescope-live-grep-args.nvim" ,
          -- This will not install any breaking changes.
          -- For major updates, this must be adjusted manually.
          version = "^1.0.0",
      },
    },
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  'rebelot/kanagawa.nvim',
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  'tmux-plugins/vim-tmux',
  'tpope/vim-obsession',
  'windwp/nvim-autopairs',
  'yangmillstheory/vim-snipe',
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' }
  },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', priority = 1001 },
  'uga-rosa/cmp-dictionary',
  'uga-rosa/utf8.nvim',
  'RRethy/vim-illuminate',
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true },
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
})
