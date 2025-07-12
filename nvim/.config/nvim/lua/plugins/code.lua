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
    opts = {
      modes = {
        preview_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor", -- Relative to the current editor window
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, 0 },
            size = { width = 0.25, height = 1 },
            zindex = 200,
          },
        },
        symbols = {
          mode = "lsp_document_symbols",
          win = {
            position = "right",
            size = { width = 0.3,  height = 1 },
          },
          focus = false,
        },
      }
    },
    keys = {
      {
        "<leader>tt",
        -- "<cmd>Trouble diagnostics toggle focus=false<cr>",
        function()
          require("trouble").toggle("preview_float")
        end,
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tb",
        function()
          require("trouble").toggle("preview_float"):filter({ buf = 0 }, { focus = false})
        end,
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle<cr>",
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
    init = function()
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false
    end
  },
}
