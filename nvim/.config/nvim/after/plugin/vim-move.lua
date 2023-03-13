local utils = require('utils')

vim.g.move_map_keys = 0

utils.keymap('v', '<A-S-h>', '<Plug>MoveBlockLeft')
utils.keymap('v', '<A-S-j>', '<Plug>MoveBlockDown')
utils.keymap('v', '<A-S-k>', '<Plug>MoveBlockUp')
utils.keymap('v', '<A-S-l>', '<Plug>MoveBlockRight')
utils.keymap('n', '<A-S-h>', '<Plug>MoveCharLeft')
utils.keymap('n', '<A-S-j>', '<Plug>MoveLineDown')
utils.keymap('n', '<A-S-k>', '<Plug>MoveLineUp')
utils.keymap('n', '<A-S-l>', '<Plug>MoveCharRight')
