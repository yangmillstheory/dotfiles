return {
  {
    'axkirillov/hbac.nvim',
    config = true,
  },
  {
    'christoomey/vim-tmux-navigator',
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
    config = function()
      local utils = require('utils')

      local keymap_opts = { silent = true }
      utils.keymap('n', '<A-h>', ':TmuxNavigateLeft<cr>', keymap_opts)
      utils.keymap('n', '<A-j>', ':TmuxNavigateDown<cr>', keymap_opts)
      utils.keymap('n', '<A-k>', ':TmuxNavigateUp<cr>', keymap_opts)
      utils.keymap('n', '<A-l>', ':TmuxNavigateRight<cr>', keymap_opts)
    end
  },
  {
    'kylechui/nvim-surround',
    config = true
  },
  {
    'matze/vim-move',
    init = function()
      vim.g.move_map_keys = 0
    end,
    config = function()
      local utils = require('utils')

      utils.keymap('v', '<A-S-j>', '<Plug>MoveBlockDown')
      utils.keymap('n', '<A-S-h>', '<Plug>MoveCharLeft')
      utils.keymap('v', '<A-S-h>', '<Plug>MoveBlockLeft')
      utils.keymap('n', '<A-S-j>', '<Plug>MoveLineDown')
      utils.keymap('n', '<A-S-k>', '<Plug>MoveLineUp')
      utils.keymap('v', '<A-S-k>', '<Plug>MoveBlockUp')
      utils.keymap('v', '<A-S-l>', '<Plug>MoveBlockRight')
      utils.keymap('n', '<A-S-l>', '<Plug>MoveCharRight')
    end
  },
  'tmux-plugins/vim-tmux',
  {
    "leath-dub/snipe.nvim",
    keys = {
      {
        "<leader>B",
        function() require("snipe").open_buffer_menu() end,
        desc = "Open Snipe buffer menu",
      }
    },
    opts = {
      ui = {
        open_win_override = {
          title = 'Buffers',
          border = 'rounded'
        },
        position = 'center',
        preselect_current = true,
      },
      navigate = {
        -- Make sure tags don't conflict with these. For
        -- example, never assign "j" and "k" tags.
        -- These are purposely similar to Telescope bindings.
        open_split = "<c-x>",
        open_vsplit = "<c-v>",
        close_buffer = "X",
        change_tag = "*",
      },
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
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
            '--no-ignore',
            '--glob', '!.git/',
            '--glob', '!.venv/'
          },
          find_command = {
            'rg',
            '--files',
            '--hidden',
            '--no-ignore',
            '--glob', '!.git/',
            '--glob', '!.venv/',
          },
        },
        extensions = {
          fzf = {},
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-t>"] = lga_actions.quote_prompt({ postfix = " --type " }),
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-fzf-nativenvim
      telescope.load_extension('fzf')
      -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim?tab=readme-ov-file#grep-argument-examples
      telescope.load_extension("live_grep_args")

      local builtin = require('telescope.builtin')
      local utils = require('utils')

      utils.keymap('n', '<leader>t', function()
        builtin.find_files({ hidden = true })
      end, { desc = 'Telescope find files' })

      -- These keymaps are important enough that we don't have a "prefix" key like t.
      -- See for example Trouble's keybindings.
      utils.keymap('n', '<leader>f',
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { desc = 'Telescope live grep' }
      )
      -- Drop this in favor of the strictly better snipe.
      utils.keymap('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
      utils.keymap('n', '<leader>c', builtin.commands, { desc = 'Telescope commands' })
      utils.keymap('n', '<leader>?', builtin.help_tags, { desc = 'Telescope help_tags' })
      utils.keymap('n', '<leader>!', builtin.diagnostics, { desc = 'Telescope diagnostics' })
      utils.keymap('n', '<leader>m', builtin.marks, { desc = 'Telescope marks' })
      utils.keymap('n', '<leader>ld', builtin.lsp_definitions, { desc = 'Telescope LSP defs' })
      utils.keymap('n', '<leader>lr', builtin.lsp_references, { desc = 'Telescope LSP refs' })
      utils.keymap('n', '<leader>li', builtin.lsp_implementations, { desc = 'Telescope LSP impl' })
      utils.keymap('n', '<leader>lt', builtin.lsp_type_definitions, { desc = 'Telescope LSP typedef' })
      utils.keymap('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'Telescope LSP buf symbols' })
      utils.keymap('n', '<leader>r', builtin.command_history, { desc = 'Telescope command history' })
      utils.keymap('n', '<leader>/', builtin.search_history, { desc = 'Telescope search history' })
      utils.keymap('n', '<leader>.', function()
        require('telescope.builtin').find_files {
          hidden = true,
          cwd = vim.fn.expand('~/code/dotfiles')
        }
      end, { desc = 'Telescope edit dotfiles' })
    end
  },
  { 'windwp/nvim-autopairs', config = true },
  {
    'yangmillstheory/vim-snipe',
    config = function()
      local utils = require('utils')
      -- Because I don't want the annoying prompt messages
      -- due to plugin output, which will happen because I set
      -- cmdheight=0 elsewhere.
      vim.g.snipe_silent = true
      -- flash.nvim is better for these keymaps.
      -- utils.keymap('', 'f', '<Plug>(snipe-F)')
      -- utils.keymap('', 'f', '<Plug>(snipe-f)')
      -- utils.keymap('', 'T', '<Plug>(snipe-T)')
      -- utils.keymap('', 't', '<Plug>(snipe-t)')
      utils.keymap('', '<leader><leader>w', '<Plug>(snipe-w)')
      utils.keymap('', '<leader><leader>W', '<Plug>(snipe-W)')
      utils.keymap('', '<leader><leader>e', '<Plug>(snipe-e)')
      utils.keymap('', '<leader><leader>E', '<Plug>(snipe-E)')
      utils.keymap('', '<leader><leader>b', '<Plug>(snipe-b)')
      utils.keymap('', '<leader><leader>B', '<Plug>(snipe-B)')
      utils.keymap('', '<leader><leader>ge', '<Plug>(snipe-ge)')
      utils.keymap('', '<leader><leader>gE', '<Plug>(snipe-gE)')
      -- Swap.
      utils.keymap('n', '<leader><leader>]', '<Plug>(snipe-f-xp)')
      utils.keymap('n', '<leader><leader>[', '<Plug>(snipe-F-xp)')
      -- Cut.
      utils.keymap('n', '<leader><leader>x', '<Plug>(snipe-f-x)')
      utils.keymap('n', '<leader><leader>X', '<Plug>(snipe-F-x)')
      -- Replace.
      utils.keymap('n', '<leader><leader>r', '<Plug>(snipe-f-r)')
      utils.keymap('n', '<leader><leader>R', '<Plug>(snipe-F-r)')
      -- Insert.
      utils.keymap('n', '<leader><leader>i', '<Plug>(snipe-f-i)')
      utils.keymap('n', '<leader><leader>I', '<Plug>(snipe-F-i)')
      -- Append.
      utils.keymap('n', '<leader><leader>a', '<Plug>(snipe-f-a)')
      utils.keymap('n', '<leader><leader>A', '<Plug>(snipe-F-a)')
    end
  },
  'tpope/vim-obsession',
  {
    -- vim-snipe doesn't give me jump labels on search.
    'folke/flash.nvim',
    opts = {
      modes = {
        char = {
          jump_labels = true,
          autohide = true,
        }
      }
    },
    keys = {
      "f", "F", "t", "T",
      { "<c-f>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  { 'folke/lazydev.nvim',    ft = "lua",   opts = {} }
}
