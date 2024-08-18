local keymap = require('utils').keymap

if not table.unpack then
  table.unpack = unpack
end

local function ToggleDone()
  local old = vim.api.nvim_get_current_line()
  local new = nil
  local status = string.match(old, "^%s*%*%s%[(.)%]%s.+$")
  if status ~= ' ' and status ~= 'x' then
    return
  end
  if status == ' ' then
    new = string.gsub(old, "%b[]", '[x]', 1)
  else
    new = string.gsub(old, "%b[]", '[ ]', 1)
  end
  local row, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row - 1, row, true, {new})
end

local function ToggleTodo()
  local pos = vim.fn.getpos('.')
  local old = vim.api.nvim_get_current_line()
  if not string.match(old, "^%s*%*%s.+$") then
    -- Not a bullet point.
    return
  end
  local new = nil
  local col_delta = 0
  if string.match(old, "^%s*%*%s%[[%s|x]%]%s.+$") then
    -- Already a todo; convert to normal bullet point.
    new = string.gsub(old, "%b[]%s", '', 1)
    -- Modify cursor to account for deleted characters
    col_delta = -4
  else
    new = string.gsub(old, "(%s*%*%s)", '%1[ ] ', 1)
    -- Modify cursor to account for inserted characters
    col_delta = 4
  end
  pos[3] = pos[3] + col_delta
  vim.api.nvim_buf_set_lines(0, pos[2] - 1, pos[2], true, {new})
  vim.fn.setpos('.', pos)
end

local function NewTodo()
  vim.cmd.normal('o* [ ]')
  vim.api.nvim_feedkeys('A ', 'n', true)
end

keymap('n', '<leader>x', '', {
  desc = 'Toggle a markdown checklist item state.',
  callback = ToggleDone,
})

keymap('n', '<leader>n', '', {
  desc = 'Create a markdown checklist item.',
  callback = NewTodo,
})

keymap('n', '<leader>t', '', {
  desc = 'Convert bullet point to a checklist item or vice-versa.',
  callback = ToggleTodo,
})

keymap('n', '<leader>z', ':ZenMode<cr>')

-- Automatically enter ZenMode for diary.md file.
vim.cmd([[
  augroup diary.md
    autocmd!
    autocmd VimEnter diary.md :ZenMode
  augroup END
]])

vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0 })
