local keymap = require('utils').keymap

function YomitanPrepareCommand()
    vim.cmd.normal('gg')
    vim.cmd.normal('0')
    -- Clear the first line.
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { "" })
    vim.opt.paste = true
    vim.api.nvim_put({vim.fn.getreg('+')}, 'l',
      false,  -- Insert text before cursor position
      false  -- Leave the cursor in original position
    )
    vim.opt.paste = false
    -- Remove null terminators
		vim.cmd([[silent! :%s/\%x00//g]])
    vim.cmd.normal('j')
    vim.cmd.normal('dd')
    vim.cmd.normal('k')
end

function RmEmptyListItems()
  vim.cmd([[silent! %s/\V<li><span><\/span><\/li>//g]])
end

function YomitanPrepareWords()
  YomitanPrepareCommand()
  vim.cmd([[silent! %s/\V<br>/\&nbsp;-\&nbsp;<br>/g]])
  vim.cmd.normal('$')
  -- FIXME: Broken when the last word ends in Kana.
  vim.cmd.normal('F<')
  vim.cmd.normal('i&nbsp;-&nbsp;')
  vim.cmd.normal('"*yy')
end

-- Keeps only the text of first bullet point in the definition list
-- and removes the surround HTML list markup.
function YomitanSimpleTerm(_)
  YomitanPrepareCommand()
  -- Alternative implementation: use the macro 0d/<i>/<\/li>d$.
  vim.fn.search('<i>')
  vim.cmd.normal('d0')
  -- NB: This won't work if the first term contains nested <li> tags.
  vim.fn.search('<\\/li>')
  vim.cmd.normal('d$')
  vim.cmd.normal('"*yy')
end

function YomitanCleanJisho(_)
  YomitanPrepareCommand()
  vim.cmd([[silent! s/;/ |/g]])
  vim.cmd.normal('"*yy')
end

vim.api.nvim_create_user_command('YomitanCleanTerm',
  function(_)
    YomitanPrepareCommand()
    -- Strip out tags like (\d+).
    vim.cmd([[silent! %s/\v\(\d+\)(\&nbsp;)?//g]])
    -- Strip out tags like (\d+, \w+).
    vim.cmd([[silent! %s/\v\(\d+,\s([^)]+)\)/(\1)/g]])
    -- Strip out "forms" list item.
    vim.cmd([[silent! %s/\v\<li\>\<i\>\(forms\)\<\/i\>.+\<\/li\>//g]])
    RmEmptyListItems()
    vim.cmd.normal('0')
    -- Check if there's just one <li> remaining.
    local li_pattern = '<li>'
    vim.fn.search(li_pattern)
    if vim.fn.searchcount({ pattern = li_pattern }).total == 1 then
      -- If there's only one definition left, remove the list markup.
      YomitanSimpleTerm()
      return
    end
    vim.cmd.normal('"*yy')
  end
, {
  desc = 'Remove redundant numerical meaning tags like (1), (2), from mined Yomitan HTML definitions.'
})


vim.api.nvim_create_user_command('YomitanCleanKanji',
  function(_)
    YomitanPrepareCommand()
    -- Strip beginning and ending HTML tags.
    vim.cmd.normal('0')
    vim.cmd.normal('3df>')
    vim.cmd.normal('$')
    vim.cmd.normal('3dF<x')
    -- Replace interior </li><li> (etc) tags with |.
    vim.cmd([[silent! %s/\v(\<\/?[oli]{2}\>){2}/ | /g]])
    RmEmptyListItems()
    vim.cmd.normal('"*yy')
  end
, {
  desc = 'Make Yomitan-mined Kanji not be HTML lists, but plain text separated by |.'
})

vim.api.nvim_create_user_command('YomitanSimpleTerm',
  YomitanSimpleTerm
, {
  desc = 'Use only the first definition of a Yomitan-mined term.'
})

vim.api.nvim_create_user_command('YomitanCleanJisho',
  YomitanCleanJisho
, {
  desc = 'Clean and copy a pasted Jisho definition.'
})

vim.api.nvim_create_user_command('YomitanPrepareWords',
  YomitanPrepareWords
, {
  desc = 'Prepare words with Furigana for a Kanji note.'
})

keymap('n', '<leader>yt', ':YomitanCleanTerm<cr>')
keymap('n', '<leader>yp', ':YomitanPrepareWords<cr>')
keymap('n', '<leader>yk', ':YomitanCleanKanji<cr>')
keymap('n', '<leader>yj', ':YomitanCleanJisho<cr>')
