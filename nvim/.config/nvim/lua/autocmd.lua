vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	desc = "Remove lines with only whitespace before writing buffer.",
	callback = function(_)
		local view = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})
