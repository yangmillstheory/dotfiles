local keymap = require('utils').keymap

keymap('n', '<space>', '<nop>')
vim.g.mapleader = ' '

-- edit common files
keymap('n', '<leader>ev', ':vsp ~/.vim/vimrc<cr>')
keymap('n', '<leader>ea', ':vsp ~/.config/alacritty/alacritty.yml<cr>')
keymap('n', '<leader>ei', ':vsp ~/.config/i3/config<cr>')
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
keymap('n', '<A-r>', ':%s//g<left><left>')
keymap('v', '<A-r>', ':s//g<left><left>')

-- writing, quitting, opening
keymap('n', '<A-w>', ':w<cr>')
keymap('n', '<A-q>', ':q<cr>')
keymap('n', '<A-cr>', ':wq<cr>')
keymap('n', '<A-e>', ':e<space>')

-- keep search, page up and down centered
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

-- navigating tabs
keymap('n', '<A-t>', ':tab sp<cr>')
keymap('n', '<A-[>', 'gT')
keymap('n', '<A-]>', 'gt')

-- JK-jumps should be in the jumplist
local M = {}
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

keymap('n', 'j', ':<C-U> | lua require("keybinds").JkJumps("j")<cr>', { silent = true })
keymap('n', 'k', ':<C-U> | lua require("keybinds").JkJumps("k")<cr>', { silent = true })

return M