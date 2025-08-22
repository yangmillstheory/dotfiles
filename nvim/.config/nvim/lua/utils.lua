local module = {}

-- Create a keymap with default options.
function module.keymap(mode, lhs, rhs, options)
  local opts = { noremap = true, silent = true }
  if options and type(options) == 'table' then
    opts = vim.tbl_extend('force', opts, options)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

return module
