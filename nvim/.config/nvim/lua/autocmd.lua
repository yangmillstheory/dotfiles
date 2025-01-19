vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = {"*"},
  desc = "Remove lines with only whitespace before writing buffer.",
  callback = function(_)
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

local group = vim.api.nvim_create_augroup("Black", { clear = true })
vim.api.nvim_create_autocmd("bufWritePost", {
  pattern = "*.py",
  -- $ brew install black
  command = "silent !black -l 80 --unstable %",
  group = group
})
