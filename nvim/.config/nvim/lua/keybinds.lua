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

-- Toggles a popup window displaying today's diary file.
-- Now, it handles existing buffers correctly.
local diary_popup_win_id = nil

local function toggle_diary_popup()
	-- Check if the popup window exists. If so, close it and return.
	if diary_popup_win_id ~= nil and vim.api.nvim_win_is_valid(diary_popup_win_id) then
		vim.api.nvim_win_close(diary_popup_win_id, true)
		diary_popup_win_id = nil
		return
	end

	local current_date = os.date("%Y-%m-%d")
	local file_path = os.getenv("HOME") .. "/Documents/Woven/Diary/" .. current_date .. ".md"

	-- Check if a buffer for this file already exists.
	local buf = vim.fn.bufnr(file_path)
	if buf == -1 then
		-- If the buffer doesn't exist, create a new one
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, file_path)

		-- Load content into the new buffer
		local file_content = {}
		local file = io.open(file_path, "r")
		if file then
			for line in file:lines() do
				table.insert(file_content, line)
			end
			file:close()
		else
			-- If the file doesn't exist, create it with a header
			table.insert(file_content, "---")
			table.insert(file_content, "title: " .. current_date)
			table.insert(file_content, "---")
			table.insert(file_content, "")
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, file_content)
	end

	-- Explicitly set the buffer's type to a normal, writable buffer.
	-- This is the new, crucial line to fix the E382 error.
	vim.api.nvim_set_option_value("buftype", "", { buf = buf })

	-- Set buffer options
	vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })

	-- Calculate window dimensions
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Open the floating window using the existing or newly created buffer
	local win_id = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		focusable = true,
		style = "minimal",
		border = "rounded",
	})

	diary_popup_win_id = win_id
	vim.api.nvim_set_option_value("winhl", "Normal:Popup", { win = win_id })

	-- Add a keymap to save and close the popup
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":w<CR>:quit<CR>", {
		noremap = true,
		silent = true,
		nowait = true,
		desc = "Save and Close Diary Popup",
	})
end

vim.keymap.set(
	"n",
	"<leader>D",
	toggle_diary_popup,
	{ noremap = true, silent = true, desc = "Toggle Daily Diary Popup" }
)

vim.keymap.set("n", "<leader>tD", function()
	local diary_file = "Diary/" .. os.date("%F") .. ".md"
	vim.cmd("!cp Diary/Template.md " .. diary_file)
	vim.cmd("edit " .. diary_file)
end, { desc = "Create today's diary from template" })

return M
