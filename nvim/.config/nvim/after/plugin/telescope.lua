local builtin = require('telescope.builtin')
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
  }
}

utils.keymap('n', '<c-t>', function()
  builtin.find_files({ hidden = true })
end, { desc = 'Telescope find files' })
utils.keymap('n', '<c-f>', builtin.live_grep, { desc = 'Telescope live grep'})
utils.keymap('n', '<c-b>', builtin.buffers, { desc = 'Telescope buffers'})
utils.keymap('n', '<c-r>', builtin.command_history, { desc = 'Telescope command history'})
utils.keymap('n', '<c-s>', builtin.search_history, { desc = 'Telescope search history'})
utils.keymap('n', '<c-c>', builtin.commands, { desc = 'Telescope commands'})
utils.keymap('n', '<c-q>', builtin.marks, { desc = 'Telescope marks'})
