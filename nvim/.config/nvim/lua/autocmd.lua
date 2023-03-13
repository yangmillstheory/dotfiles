local api = vim.api

local vimrc = api.nvim_create_augroup('vimrc', { clear = true })
api.nvim_create_autocmd({ 'BufRead' }, {
  pattern = 'vimrc',
  callback = function(t)
    vim.opt_local.foldmethod = 'marker'
    vim.opt_local.foldlevelstart = 0
  end
})
