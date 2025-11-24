local keymap = require("utils").keymap

function ToggleDone()
	local line = vim.api.nvim_get_current_line()
	local new_line = line:gsub("%[ %]", "[x]", 1)
	if new_line == line then
		new_line = line:gsub("%[x%]", "[ ]", 1)
	end
	vim.api.nvim_set_current_line(new_line)
end

keymap("n", "<leader>xt", "", {
	desc = "Toggle a markdown checklist item state.",
	callback = ToggleDone,
})

vim.api.nvim_create_user_command("LoadJp", function()
	require("jp")
end, {})

vim.opt_local.wrap = true
