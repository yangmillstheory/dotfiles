return {
  {
    'axkirillov/hbac.nvim',
    config = true,
  },
  {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end
  },
  {
    'kylechui/nvim-surround',
    config = true
  },
  {
    'matze/vim-move',
    config = function()
      local utils = require('utils')

      vim.g.move_map_keys = 0

      utils.keymap('v', '<A-S-h>', '<Plug>MoveBlockLeft')
      utils.keymap('v', '<A-S-j>', '<Plug>MoveBlockDown')
      utils.keymap('v', '<A-S-k>', '<Plug>MoveBlockUp')
      utils.keymap('v', '<A-S-l>', '<Plug>MoveBlockRight')
      utils.keymap('n', '<A-S-h>', '<Plug>MoveCharLeft')
      utils.keymap('n', '<A-S-j>', '<Plug>MoveLineDown')
      utils.keymap('n', '<A-S-k>', '<Plug>MoveLineUp')
      utils.keymap('n', '<A-S-l>', '<Plug>MoveCharRight')
    end
  },
  'tmux-plugins/vim-tmux',
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
    opts = function()
      local lga_actions = require("telescope-live-grep-args.actions")

      return {
        defaults = {
          file_ignore_patterns = { ".git/" },
          vimgrep_arguments = {
            'rg',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob',
            '!.git/'
          }
        },
        pickers = {
          live_grep = {
            theme = 'ivy'
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-space>"] = lga_actions.to_fuzzy_refine,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("live_grep_args")

      local builtin = require('telescope.builtin')
      local utils = require('utils')

      utils.keymap('n', '<c-t>', function()
        builtin.find_files({ hidden = true })
      end, { desc = 'Telescope find files' })
      utils.keymap('n', '<c-f>', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = 'Telescope live grep' })
      utils.keymap('n', '<c-b>', builtin.buffers, { desc = 'Telescope buffers' })
      utils.keymap('n', '<c-r>', builtin.command_history, { desc = 'Telescope command history' })
      utils.keymap('n', '<c-s>', builtin.search_history, { desc = 'Telescope search history' })
      utils.keymap('n', '<c-c>', builtin.commands, { desc = 'Telescope commands' })
      utils.keymap('n', '<c-q>', builtin.marks, { desc = 'Telescope marks' })
    end
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'windwp/nvim-autopairs', config = true },
  'yangmillstheory/vim-snipe',
  'tpope/vim-obsession',
}
