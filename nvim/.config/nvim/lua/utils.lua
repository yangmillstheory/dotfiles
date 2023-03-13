local module = {}

-- Create a keymap with default options.
function module.keymap(mode, lhs, rhs, options)
  local o = { noremap = true }
  if options then
    o = vim.tbl_extend('force', o, options)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, o)
end

return module
