local builtin = require('telescope.builtin')
local telescope = require('telescope')
local lga_actions = require("telescope-live-grep-args.actions")
local utils = require('utils')

require('telescope').setup {
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
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          -- freeze the current list and start a fuzzy search in the frozen list
          ["<C-space>"] = lga_actions.to_fuzzy_refine,
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}

telescope.load_extension("live_grep_args")

utils.keymap('n', '<c-t>', function()
  builtin.find_files({ hidden = true })
end, { desc = 'Telescope find files' })
utils.keymap('n', '<c-f>', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = 'Telescope live grep'})
utils.keymap('n', '<c-b>', builtin.buffers, { desc = 'Telescope buffers'})
utils.keymap('n', '<c-r>', builtin.command_history, { desc = 'Telescope command history'})
utils.keymap('n', '<c-s>', builtin.search_history, { desc = 'Telescope search history'})
utils.keymap('n', '<c-c>', builtin.commands, { desc = 'Telescope commands'})
utils.keymap('n', '<c-q>', builtin.marks, { desc = 'Telescope marks'})
