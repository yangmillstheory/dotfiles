local keymap = require("utils").keymap

keymap("n", "<space>", "<nop>", { desc = "Disable space key in normal mode" })
vim.g.mapleader = " "

-- marks
keymap("n", "xM", [[:delm! \| delm A-Z0-9a-z<CR>]], { desc = "Delete all marks" })
keymap("n", "xm", [[:delm a-z<CR>]], { desc = "Delete buffer-local marks" })

-- quickfix / diagnostics
keymap("n", "xj", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic" })
keymap("n", "xk", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic" })
keymap("n", "qj", ":cnext<cr>", { desc = "Quickfix: Next item" })
keymap("n", "qk", ":cprev<cr>", { desc = "Quickfix: Previous item" })

-- edit common files
keymap("n", "<leader>es", ":vsp scrap<cr>", { desc = "Edit scrap file in vertical split" })

-- black hole register
keymap("n", '""', '"_', { desc = "Use black hole register" })

-- redo
keymap("n", "U", ":redo<cr>", { desc = "Redo" })

-- yank into the system clipboard
keymap("n", "<A-y>", '"+y', { desc = "Yank to system clipboard (normal)" })
keymap("v", "<A-y>", '"+y', { desc = "Yank to system clipboard (visual)" })

-- folding & unfolding
keymap("n", "<A-z>", "za", { desc = "Toggle fold (normal)" })
keymap("v", "<A-z>", "za", { desc = "Toggle fold (visual)" })

-- search & replace
keymap("n", "<leader><esc>", ":noh<cr>", { silent = true, desc = "Clear search highlight" })
keymap("n", "<A-r>", ":%s/\\v//g<left><left><left>", { desc = "Global search and replace" })
keymap("v", "<A-r>", ":s/\\v//g<left><left><left>", { desc = "Search and replace in selection" })

-- writing, quitting, opening
keymap("n", "<A-w>", ":w<cr>", { desc = "Write buffer" })
keymap("n", "<A-q>", ":q<cr>", { desc = "Quit buffer" })
keymap("n", "<A-cr>", ":wq<cr>", { desc = "Write and quit buffer" })
keymap("n", "<A-e>", ":e!<cr>", { desc = "Reload buffer" })

-- keep search, page up and down centered
keymap("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
keymap("n", "n", "nzzzv", { desc = "Next search result and center" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result and center" })
keymap("n", "}", "}zz", { desc = "Next paragraph and center" })
keymap("n", "{", "{zz", { desc = "Previous paragraph and center" })

-- navigating tabs & buffers
keymap("n", "<A-t>", ":tab sp<cr>", { desc = "Open new tab" })

-- resizing windows
keymap("n", "<C-A-k>", ":resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-A-j>", ":resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-A-h>", ":vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-A-l>", ":vertical resize +2<cr>", { desc = "Increase window width" })

-- uninterrupted indent
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

local M = {}

-- joining lines keeps original cursor position
function M.NonDestructiveJoin()
	local pos = vim.fn.getpos(".")
	vim.cmd.join()
	vim.fn.setpos(".", pos)
end

keymap("n", "J", ':lua require("keybinds").NonDestructiveJoin()<cr>', { desc = "Join lines without moving cursor" })

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

keymap("n", "j", ':<C-U>lua require("keybinds").JkJumps("j")<cr>', { desc = "Jump down and add to jumplist" })
keymap("n", "k", ':<C-U>lua require("keybinds").JkJumps("k")<cr>', { desc = "Jump up and add to jumplist" })

return M
