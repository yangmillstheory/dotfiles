local o = vim.o
local g = vim.g

o.showmode = false
o.cursorcolumn = true
o.cursorline = true

o.confirm = true
o.hlsearch = false

o.wrap = true
o.expandtab = true

o.relativenumber = true
o.number = true

o.cmdheight = 0

o.wildignore = table.concat({'*.o', '*.a', '*.obj', '__pycache__'}, ',')

o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2

o.swapfile = false

o.inccommand = 'split'

g.loaded_ruby_provider = false
g.loaded_node_provider = false
