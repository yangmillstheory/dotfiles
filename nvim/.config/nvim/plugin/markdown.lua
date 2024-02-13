local keymap = require('utils').keymap

if not table.unpack then
  table.unpack = unpack
end

local function ToggleTodo()
  local old_todo = vim.api.nvim_get_current_line()
  local new_todo = nil
  local status = string.match(old_todo, "^%s*%*%s%[(.)%]%s.+$")
  if status ~= ' ' and status ~= 'x' then
    return
  end
  if status == ' ' then
    new_todo = string.gsub(old_todo, "%b[]", '[x]', 1)
  else
    new_todo = string.gsub(old_todo, "%b[]", '[ ]', 1)
  end
  local row, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row - 1, row, true, {new_todo})
end

local function NewTodo()
  vim.cmd.normal('o* [ ]')
  vim.api.nvim_feedkeys('A ', 'n', true)
end

keymap('n', '<leader>x', '', {
  desc = 'Toggle a markdown checklist item.',
  callback = ToggleTodo,
})

keymap('n', '<leader>n', '', {
  desc = 'Create a markdown checklist item.',
  callback = NewTodo,
})
