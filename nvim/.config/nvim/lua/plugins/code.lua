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
    init = function()
      vim.o.list = true
      vim.g.indent_blankline_filetype = { "cpp", "python", "lua", "typescript", "javascript", "go"}
    end,
  },
  'RRethy/vim-illuminate',
  {
    'folke/trouble.nvim',
    keys = {
      {
        "<leader>xt",
        "<cmd>Trouble diagnostics toggle focus=false<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xb",
        "<cmd>Trouble diagnostics toggle filter.buf=0 focus=false<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false win.position=right win.size.width=0.25<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
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
    init = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false
    end
  },
}
