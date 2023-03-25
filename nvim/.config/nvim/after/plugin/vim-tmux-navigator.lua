local utils = require('utils')

local keymap_opts = { silent = true }
utils.keymap('n', '<A-h>', ':TmuxNavigateLeft<cr>', keymap_opts)
utils.keymap('n', '<A-j>', ':TmuxNavigateDown<cr>', keymap_opts)
utils.keymap('n', '<A-k>', ':TmuxNavigateUp<cr>', keymap_opts)
utils.keymap('n', '<A-l>', ':TmuxNavigateRight<cr>', keymap_opts)
