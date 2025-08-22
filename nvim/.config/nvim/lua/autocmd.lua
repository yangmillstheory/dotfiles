vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	desc = "Remove lines with only whitespace before writing buffer.",
	callback = function(_)
		local view = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

local group = vim.api.nvim_create_augroup("Black", { clear = true })
vim.api.nvim_create_autocmd("bufWritePost", {
	group = group,
	pattern = "*.py",
	-- $ brew install black
	callback = function()
		local filepath = vim.fn.expand("%:p")
		if vim.fn.filereadable(filepath) ~= 1 then
			return
		end
		vim.cmd("silent! !black -l 80 --unstable " .. filepath)
	end,
	desc = "Run Black on Python files after saving",
})

local prettier_augroup = vim.api.nvim_create_augroup("PrettierOnTS", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = prettier_augroup,
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		local filepath = vim.fn.expand("%:p")
		if vim.fn.filereadable(filepath) ~= 1 then
			return
		end
		local command_to_run

		local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
		if not git_root or git_root == "" then
			git_root = vim.fn.getcwd()
		end

		if (vim.fn.executable("direnv") == 1) and (vim.fn.filereadable(git_root .. "/.envrc") == 1) then
			command_to_run = string.format(
				"cd %s && direnv exec . yarn prettier --write %s",
				vim.fn.shellescape(git_root),
				vim.fn.shellescape(filepath)
			)
		else
			command_to_run = string.format("yarn prettier --write %s", vim.fn.shellescape(filepath))
		end
		vim.cmd("silent! !" .. command_to_run)
	end,
	desc = "Run Prettier on TypeScript/JavaScript files after saving",
})
