local fold_preview = require('fold-preview')

fold_preview.setup({
    default_keybindings = false
})

local keymap = vim.keymap
keymap.amend = require('keymap-amend')
keymap.amend('n', 'zp',  function(_)
   fold_preview.toggle_preview()
end)

-- Take these defaults, but not h and l, which don't make sense.
local map = fold_preview.mapping
keymap.amend('n', 'zo', map.close_preview)
keymap.amend('n', 'zO', map.close_preview)
keymap.amend('n', 'zc', map.close_preview_without_defer)
keymap.amend('n', 'zR', map.close_preview)
keymap.amend('n', 'zM', map.close_preview_without_defer)
