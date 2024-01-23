local keymap = require('utils').keymap

keymap('n', '<space>', '<nop>')
vim.g.mapleader = ' '

-- edit common files
keymap('n', '<leader>el', ':vsp ~/.config/nvim/init.lua<cr>')
keymap('n', '<leader>ea', ':vsp ~/.config/alacritty/alacritty.toml<cr>')
keymap('n', '<leader>et', ':vsp ~/.tmux.conf<cr>')
keymap('n', '<leader>ez', ':vsp ~/.zshrc<cr>')
keymap('n', '<leader>es', ':vsp scrap<cr>')

-- black hole register
keymap('n', '""', '"_')

-- redo
keymap('n', 'U', ':redo<cr>')

-- quickly get into normal mode
keymap('n', '<cr><cr>', ':')
keymap('v', '<cr><cr>', ':')

-- yank into the system clipboard
keymap('n', '<A-y>', '"+y')
keymap('v', '<A-y>', '"+y')

-- folding & unfolding
keymap('n', '<A-z>', 'za')
keymap('v', '<A-z>', 'za')

-- search & replace
keymap('n', '<leader><esc>', ':noh<cr>', { silent = true })
keymap('n', '<A-r>', ':%s///g<left><left><left>')
keymap('v', '<A-r>', ':s///g<left><left><left>')

-- writing, quitting, opening
keymap('n', '<A-w>', ':w<cr>')
keymap('n', '<A-q>', ':q<cr>')
keymap('n', '<A-cr>', ':wq<cr>')
keymap('n', '<A-e>', ':e!<cr>')
keymap('n', '<A-d>', ':cd $PWD<cr>')

-- keep search, page up and down centered
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
keymap('n', '}', '}zz')
keymap('n', '{', '{zz')

-- navigating tabs
keymap('n', '<A-t>', ':tab sp<cr>')
keymap('n', '<A-[>', 'gT')
keymap('n', '<A-]>', 'gt')

-- resizing windows
keymap('n', '<C-k>', ':resize +2<cr>')
keymap('n', '<C-j>', ':resize -2<cr>')
keymap('n', '<C-h>', ':vertical resize -2<cr>')
keymap('n', '<C-l>', ':vertical resize +2<cr>')

-- uninterrupted indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

local M = {}

-- joining lines keeps original cursor position
function M.NonDestructiveJoin()
  local pos = vim.fn.getpos('.')
  vim.cmd.join()
  vim.fn.setpos('.', pos)
end
keymap('n', 'J', ':lua require("keybinds").NonDestructiveJoin()<cr>')

-- vertical jumps should be in the jumplist
function M.JkJumps(j_or_k)
  vim.cmd { cmd = 'normal', bang = true, args = { vim.v.count1 .. j_or_k } }
  if vim.v.count1 > 1 then
    local target = vim.fn.line('.')
    local k_or_j = j_or_k == 'j' and 'k' or 'j'
    -- jump back to the origin, which adds the movement to the jumplist
    vim.cmd { cmd = 'normal', bang = true, args = { vim.v.count1 .. k_or_j } }
    vim.cmd { cmd = 'normal', bang = true, args = { target .. 'G' } }
  end
end
keymap('n', 'j', ':<C-U>lua require("keybinds").JkJumps("j")<cr>', { silent = true })
keymap('n', 'k', ':<C-U>lua require("keybinds").JkJumps("k")<cr>', { silent = true })

return M
