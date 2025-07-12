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
          separator_style = "slant",
          indicator = {
            style = 'underline'
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
    "ellisonleao/gruvbox.nvim",
    priority = 1000 ,
    lazy = false,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
        italic = {
          comments = true,
          strings = true,
        }
      })
      vim.o.background = 'dark'
      vim.cmd.colorscheme("gruvbox")
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
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local lualine = require('lualine')
      lualine.setup({
        options = { theme = 'gruvbox' },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            get_obsession_status,
            'diff',
            'diagnostics',
            show_macro_recording,
          },
          lualine_c = {
            {
              'filename',
              path = 1,
              symbols = {
                modified = '✗',
                readonly = '',
              },
            },
          }
        },
      })
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
