local keymap = require("utils").keymap

keymap("n", "<space>", "<nop>")
vim.g.mapleader = " "

-- marks
keymap("n", "xM", [[:delm! \| delm A-Z0-9a-z<CR>]], { desc = "Delete all marks" })
keymap("n", "xm", [[:delm a-z<CR>]], { desc = "Delete buffer-local marks" })

-- quickfix / diagnostics
keymap("n", "xj", function()
	vim.diagnostic.jump({ count = 1 })
end)
keymap("n", "xk", function()
	vim.diagnostic.jump({ count = -1 })
end)
keymap("n", "qj", ":cnext<cr>")
keymap("n", "qk", ":cprev<cr>")

-- edit common files
keymap("n", "<leader>es", ":vsp scrap<cr>")

-- black hole register
keymap("n", '""', '"_')

-- redo
keymap("n", "U", ":redo<cr>")

-- quickly get into normal mode
keymap("n", "<cr><cr>", ":")
keymap("v", "<cr><cr>", ":")

-- yank into the system clipboard
keymap("n", "<A-y>", '"+y')
keymap("v", "<A-y>", '"+y')

-- folding & unfolding
keymap("n", "<A-z>", "za")
keymap("v", "<A-z>", "za")

-- search & replace
keymap("n", "<leader><esc>", ":noh<cr>", { silent = true })
keymap("n", "<A-r>", ":%s/\\v//g<left><left><left>")
keymap("v", "<A-r>", ":s/\\v//g<left><left><left>")

-- writing, quitting, opening
keymap("n", "<A-w>", ":w<cr>")
keymap("n", "<A-q>", ":q<cr>")
keymap("n", "<A-cr>", ":wq<cr>")
keymap("n", "<A-e>", ":e!<cr>")

-- keep search, page up and down centered
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "}", "}zz")
keymap("n", "{", "{zz")

-- navigating tabs & buffers
keymap("n", "<A-t>", ":tab sp<cr>")

-- resizing windows
keymap("n", "<C-A-k>", ":resize +2<cr>")
keymap("n", "<C-A-j>", ":resize -2<cr>")
keymap("n", "<C-A-h>", ":vertical resize -2<cr>")
keymap("n", "<C-A-l>", ":vertical resize +2<cr>")

-- uninterrupted indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

local M = {}

-- joining lines keeps original cursor position
function M.NonDestructiveJoin()
	local pos = vim.fn.getpos(".")
	vim.cmd.join()
	vim.fn.setpos(".", pos)
end

keymap("n", "J", ':lua require("keybinds").NonDestructiveJoin()<cr>')

-- vertical jumps should be in the jumplist
function M.JkJumps(j_or_k)
	vim.cmd({ cmd = "normal", bang = true, args = { vim.v.count1 .. j_or_k } })
	if vim.v.count1 > 1 then
		local target = vim.fn.line(".")
		local k_or_j = j_or_k == "j" and "k" or "j"
		-- jump back to the origin, which adds the movement to the jumplist
		vim.cmd({ cmd = "normal", bang = true, args = { vim.v.count1 .. k_or_j } })
		vim.cmd({ cmd = "normal", bang = true, args = { target .. "G" } })
	end
end

keymap("n", "j", ':<C-U>lua require("keybinds").JkJumps("j")<cr>', { silent = true })
keymap("n", "k", ':<C-U>lua require("keybinds").JkJumps("k")<cr>', { silent = true })

return M
