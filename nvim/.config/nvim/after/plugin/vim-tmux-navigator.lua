local utils = require('utils')
local g = vim.g

g.tmux_navigator_no_mappings = 1
g.tmux_navigator_disable_when_zoomed = 1

local keymap_opts = { silent = true }
utils.keymap('n', '<A-h>', ':TmuxNavigateLeft<cr>', keymap_opts)
utils.keymap('n', '<A-j>', ':TmuxNavigateDown<cr>', keymap_opts)
utils.keymap('n', '<A-k>', ':TmuxNavigateUp<cr>', keymap_opts)
utils.keymap('n', '<A-l>', ':TmuxNavigateRight<cr>', keymap_opts)
