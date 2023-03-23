local keymap = require('utils').keymap

require('bufferline').setup({})

keymap('n', 'bq', ':bw<CR>')
keymap('n', 'bj', ':BufferLineCyclePrev<CR>')
keymap('n', 'bk', ':BufferLineCycleNext<CR>')
keymap('n', 'bg', ':BufferLinePick<CR>')
