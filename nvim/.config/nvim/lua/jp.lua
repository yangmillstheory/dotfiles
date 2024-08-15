local keymap = require('utils').keymap
local utf8 = require('utf8')

function StartCommand()
  local start_pos = vim.api.nvim_win_get_cursor(0)
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
  return start_pos
end

function EndCommand(start_pos)
  vim.cmd.normal('"*yy')
  vim.api.nvim_win_set_cursor(0, start_pos)
end

function RmEmptyListItems()
  vim.cmd([[silent! %s/\V<li><span><\/span><\/li>//g]])
end

function YomitanPrepareWords()
  local start_pos = StartCommand()
  vim.cmd([[silent! %s/\V<br>/\&nbsp;-\&nbsp;<br>/g]])
  vim.cmd.normal('$')
  -- FIXME: Broken when the last word ends in Kana.
  vim.cmd.normal('F<')
  vim.cmd.normal('i&nbsp;-&nbsp;')
  EndCommand(start_pos)
end

-- Keeps only the text of first bullet point in the definition list
-- and removes the surround HTML list markup.
function YomitanSimpleTerm(_)
  local start_pos = StartCommand()
  -- Alternative implementation: use the macro 0d/<i>/<\/li>d$.
  vim.fn.search('<i>')
  vim.cmd.normal('d0')
  -- NB: This won't work if the first term contains nested <li> tags.
  vim.fn.search('<\\/li>')
  vim.cmd.normal('d$')
  EndCommand(start_pos)
end

function YomitanCleanJisho(_)
  local start_pos = StartCommand()
  vim.cmd([[silent! s/;/ |/g]])
  EndCommand(start_pos)
end

vim.api.nvim_create_user_command('YomitanCleanDefinition',
  function(_)
    local start_pos = StartCommand()
    -- Strip out tags like (\d+).
    vim.cmd([[silent! %s/\v\(\d+\)(\&nbsp;)?//g]])
    -- Strip out tags like (\d+, \w+).
    vim.cmd([[silent! %s/\v\(\d+,\s([^)]+)\)/(\1)/g]])
    -- Strip out "forms" list item.
    -- First normalize all the li by removing useless data attributes.
    vim.cmd([[silent! %s/\V\sdata-dictionary="JMdict"//g]])
    vim.cmd([[silent! %s/\V\sstyle="text-align: left;"//g]])
    vim.cmd([[silent! %s/\V\sclass="yomitan-glossary"//g]])
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
    -- Remove outer div.
    vim.cmd([[silent! %s/\v\<div\>(.+)\<\/div\>/\1/g]])
    EndCommand(start_pos)
  end
, {
  desc = 'Remove redundant numerical meaning tags like (1), (2), from mined Yomitan HTML definitions.'
})


vim.api.nvim_create_user_command('YomitanCleanKanji',
  function(_)
    local start_pos = StartCommand()
    -- Strip beginning and ending HTML tags.
    vim.cmd.normal('0')
    vim.cmd.normal('3df>')
    vim.cmd.normal('$')
    vim.cmd.normal('3dF<x')
    -- Replace interior </li><li> (etc) tags with |.
    vim.cmd([[silent! %s/\v(\<\/?[oli]{2}\>){2}/ | /g]])
    -- Special case: there's only one definition.
    vim.cmd([[silent! %s/\v^\<[^>]+\>(\w+)\<\/\w+\>$/\1/g]])
    RmEmptyListItems()
    EndCommand(start_pos)
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

vim.api.nvim_create_user_command('LookupKanji',
  function (opts)
    local kanji = opts.args
    local codepoint = utf8.codepoint(kanji)
    if (codepoint < 0x4E00 or codepoint > 0x9FFF) and (codepoint < 0x3400 or codepoint > 0x4DBF) then
      print(string.format('%s is not a valid Japanese Kanji.', kanji))
      return
    end
    local urls = {
      "https://www.immersionkit.com/dictionary?keyword=%s&exact=true&sort=shortness&category=drama#",
      "https://kanji.koohii.com/study/kanji/%s",
      "https://jisho.org/search/*%s*",
    }
    for _, url in ipairs(urls) do
      vim.loop.spawn(
        "open",
        { args = { string.format(url, kanji) } },
        function() end
      )
    end
  end,
  {
    desc = 'Open relevant Kanji webpages to start Anki card creation process.',
    nargs = 1,
  }
)

keymap('n', '<leader>kl', ':LookupKanji <c-r><c-w><cr>')
keymap('n', '<leader>yd', ':YomitanCleanDefinition<cr>')
keymap('n', '<leader>yp', ':YomitanPrepareWords<cr>')
keymap('n', '<leader>yk', ':YomitanCleanKanji<cr>')
keymap('n', '<leader>yj', ':YomitanCleanJisho<cr>')
keymap('n', '<leader>jd', ':<C-U>lua vim.cmd.edit("~/diary/tcj/" .. os.date("%Y_%m_%d") .. ".md")<cr>', { silent = true })
