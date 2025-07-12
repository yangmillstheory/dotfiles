return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      exclude = {
        filetypes = {
          -- breaks tree-sitter highlighting
          'html',
          -- defaults
          'lspinfo',
          'packer',
          'checkhealth',
          'help',
          'man',
          'gitcommit',
        }
      }
    },
    ft = { "c", "cpp", "python", "go"},
    config = function()
      vim.o.list = true
      vim.g.indent_blankline_filetype = { "cpp", "python", "lua", "typescript", "javascript", "go"}
    end
  },
  'RRethy/vim-illuminate',
  {
    'folke/trouble.nvim',
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>tt",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>tb",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>ts",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>tl",
          "<cmd>Trouble lsp toggle focus=false<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>td",
          "<cmd>Trouble lsp_definitions<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    priority = 1001,
    opts = {
      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "query",

        'markdown',
        'markdown_inline',
      },

      ignore_install = {},
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      }
    },
    config = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false
    end
  },
  {
    'folke/trouble.nvim',
    action_keys = {
      open_split = { "<c-i>" },
      open_vsplit = { "<c-s>" },
      open_tab = { "<c-t>" },
    }
  }
}
