local api = vim.api

local vimrc = api.nvim_create_augroup('vimrc', { clear = true })
api.nvim_create_autocmd({ 'BufRead' }, {
  pattern = 'vimrc',
  callback = function(t)
    vim.opt_local.foldmethod = 'marker'
    vim.opt_local.foldlevelstart = 0
  end
})

-- Strip trailing whitespace.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = {"*"},
  callback = function(_)
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
