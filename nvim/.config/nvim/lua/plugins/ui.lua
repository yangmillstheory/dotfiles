-- Plugins that make nvim prettier.

-- Force lualine to show macro recording status, since we set cmdheight=0 elsewhere.
--
-- https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
-- https://github.com/neovim/neovim/issues/19193
local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

local function get_obsession_status()
  if vim.fn.exists("ObsessionStatus") == 1 and type(vim.fn.ObsessionStatus()) == 'string' then
    return vim.fn.ObsessionStatus()
  else
    return ""
  end
end

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
    priority = 1000 ,
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
    priority = 1000 ,
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
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/trouble.nvim' },
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
        get_obsession_status,
        'diff',
        'diagnostics',
        show_macro_recording,
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
      require('markview').setup({
        headings = require("markview.presets").headings.glow_labels,
        markdown = {
          list_items = {
            enable = true,
            shift_width = 2,
            indent_size = 2,
          },
        },
      })
      vim.cmd("Markview Enable")
    end
  },
}
