local keymap = require('utils').keymap

-- TODO: handle different kinds of markdown bullets, like -
if not table.unpack then
  table.unpack = unpack
end

-- Using "-" makes it compatible with markview.nvim's rendering.
local function ToggleDone()
  local old = vim.api.nvim_get_current_line()
  local new = nil
  local status = string.match(old, "^%s*%*%s%[(.)%]%s.+$")
  if status ~= ' ' and status ~= '-' then
    return
  end
  if status == ' ' then
    new = string.gsub(old, "%b[]", '[-]', 1)
  else
    new = string.gsub(old, "%b[]", '[ ]', 1)
  end
  local row, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row - 1, row, true, { new })
end

local function NewTodo()
  vim.cmd.normal('o* [ ]')
  vim.api.nvim_feedkeys('A ', 'n', true)
end

keymap('n', '<leader>xt', '', {
  desc = 'Toggle a markdown checklist item state.',
  callback = ToggleDone,
})

keymap('n', '<leader>nt', '', {
  desc = 'Create a markdown checklist item.',
  callback = NewTodo,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.cursorcolumn = false
  end,
})

require('jp')
