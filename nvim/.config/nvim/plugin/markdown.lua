local keymap = require('utils').keymap

if not table.unpack then
  table.unpack = unpack
end

function TodoPattern(is_checked)
  return '^%s*%*%s%[' .. (is_checked and 'x' or '%s') .. '%]%s.+$'
end

function UpdateTodo(old_todo, is_done)
  return string.gsub(old_todo, "%b[]", is_done and '[x]' or '[ ]', 1)
end

keymap('n', '<c-x>', '', {
  desc = 'Toggle a markdown checklist item.',
  callback = function (_)
    local old_todo = vim.api.nvim_get_current_line()
    local new_todo = nil
    if string.match(old_todo, TodoPattern(false)) then
      new_todo = UpdateTodo(old_todo, true)
    elseif string.match(old_todo, TodoPattern(true)) then
      new_todo = UpdateTodo(old_todo, false)
    else return end
    local row, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row - 1, row, true, {new_todo})
  end
})
