-- Plugins that make nvim prettier.
return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local keymap = require('utils').keymap
      local bufferline = require('bufferline')
      bufferline.setup({
        options = {
          -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          separator_style = "slope",
          indicator = {
            style = 'none'
          }
        },
      })
      keymap('n', 'bq', ':bw<CR>')
      keymap('n', 'bj', ':BufferLineCyclePrev<CR>')
      keymap('n', 'bk', ':BufferLineCycleNext<CR>')
      keymap('n', 'bg', ':BufferLinePick<CR>')
    end
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("kanagawa").setup({
        transparent = false,
        dimInactive = true,
        theme = 'wave',
      })
      vim.o.background = 'dark'
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("gruvbox").setup({
        transparent_mode = false,
        dim_inactive = true,
        contrast = 'hard',
      })
      -- vim.o.background = 'dark'
      -- vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
      'csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'csv_pipe', 'rfc_csv', 'rfc_semicolon'
    },
    cmd = {
      'RainbowDelim', 'RainbowDelimSimple', 'RainbowDelimQuoted', 'RainbowMultiDelim'
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'folke/trouble.nvim',
      'yavorski/lualine-macro-recording.nvim',
    },
    opts = function(_, opts)
      local trouble = require("trouble")

      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })

      opts.options = opts.options or {}
      opts.options.theme = 'auto'

      opts.sections = opts.sections or {}
      opts.sections.lualine_a = { 'mode' }
      opts.sections.lualine_b = {
        'ObsessionStatus',
        'diff',
        'diagnostics',
        'macro_recording',
      }
      opts.sections.lualine_c = {
        {
          'filename',
          path = 1,
          symbols = {
            modified = '✗',
            readonly = '',
          },
        },
        {
          symbols.get,
          cond = symbols.has,
        },
      }

      return opts
    end,
    lazy = false,
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('markview').setup()
      vim.cmd("Markview Enable")
    end
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },
  {
    "karb94/neoscroll.nvim",
    opts = {},
  },
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  -- Lua
  {
    "folke/zen-mode.nvim",
    opts = {
      window  = {
        height = .85
      },
      plugins = {
        alacritty = {
          enabled = true,
          font = "14",
        }
      }
    }
  }
}
