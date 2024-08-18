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
