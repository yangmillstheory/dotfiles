local o = vim.o
local g = vim.g

o.showmode = false
o.cursorcolumn = true
o.cursorline = true

o.wrap = false
o.expandtab = true

o.relativenumber = true
o.number = true

o.wildignore = table.concat({'*.o', '*.a', '*.obj', '__pycache__'}, ',')
o.termguicolors = true

o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2

o.inccommand = 'split'
o.scrolloff = 8

g.loaded_ruby_provider = false
g.loaded_node_provider = false
