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

local function _lookup(url_templates, query)
  for _, url_template in ipairs(url_templates) do
    local url = { string.format(url_template, query) }
    vim.loop.spawn(
      "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
      { args = url },
      function(code, signal)
        if code == 0 then
          return
        end
        print(string.format('Opening URL %s exited with code: %d and signal %d',
          url, code, signal))
      end
    )
  end
end

local function _is_jp_char(codepoint)
  if type(codepoint) ~= "number" then
    return false
  end
  return (codepoint >= 0x4E00 and codepoint <= 0x9FFF) or    -- Kanji
    (codepoint >= 0x3400 and codepoint <= 0x4DBF) or    -- Kanji Extension
    (codepoint >= 0x20000 and codepoint <= 0x2A6DF) or  -- Kanji Supplement
    (codepoint >= 0x2A700 and codepoint <= 0x2B73F) or  -- Kanji Supplement
    (codepoint >= 0x2B740 and codepoint <= 0x2B81F) or  -- Kanji Supplement
    (codepoint >= 0x2B820 and codepoint <= 0x2CEAF) or  -- Kanji Supplement
    (codepoint >= 0x2CEB0 and codepoint <= 0x2EBEF) or  -- Kanji Supplement
    (codepoint >= 0x3040 and codepoint <= 0x309F) or    -- Hiragana
    (codepoint >= 0x30A0 and codepoint <= 0x30FF)       -- Katakana
end


vim.api.nvim_create_user_command('LookupKanji',
  function (opts)
    local kanji = opts.args
    if not _is_jp_char(utf8.codepoint(kanji)) then
      print(string.format('%s is not a valid Japanese Kanji.', kanji))
      return
    end
    _lookup({
      "https://www.immersionkit.com/dictionary?keyword=%s&sort=shortness&category=drama#",
      "https://kanji.koohii.com/study/kanji/%s",
      "https://jisho.org/search/*%s*",
      -- Ask for audio on the off-chance that it exists.
      "https://tatoeba.org/en/sentences/search?from=jpn&has_audio=yes&query=%s&sort=relevance&to=eng&trans_to=eng",
      -- No audio required.
      "https://tatoeba.org/en/sentences/search?from=jpn&query=%s&sort=relevance&to=eng&trans_to=eng",
    }, kanji)
  end,
  {
    desc = 'Open relevant webpages to start Anki Kanji card creation process.',
    nargs = 1,
  }
)

vim.api.nvim_create_user_command('LookupTerm',
  function ()
    local term = vim.fn.expand('<cWORD>')
    for _, cp in utf8.codes(term) do
      -- NB: Using https://github.com/uga-rosa/utf8.nvim/blob/954cbbadabe5cd19f202e918fec191d64eea7766/lua/utf8.lua#L158
      -- Don't be misled by https://www.lua.org/manual/5.4/manual.html#pdf-utf8.codes. This API doesn't exist in the current
      -- Lua runtime, which is Lua 5.1. `cp` is actually a string, not an integer, despite any LSP warnings.
      if not _is_jp_char(utf8.codepoint(cp)) then
        print(
          string.format('%s is not a valid Japanese Kanji because of %s.',
          term, cp)
        )
        return
      end
    end
    _lookup({
      "https://www.immersionkit.com/dictionary?keyword=%s&sort=shortness&category=drama#",
      -- Ask for audio on the off-chance that it exists.
      "https://tatoeba.org/en/sentences/search?from=jpn&has_audio=yes&query=%s&sort=relevance&to=eng&trans_to=eng",
      -- No audio required.
      "https://tatoeba.org/en/sentences/search?from=jpn&query=%s&sort=relevance&to=eng&trans_to=eng",
      }, term)
  end,
  {
    desc = 'Open relevant webpages to start Anki Term card creation process.',
    nargs = 0,
  }
)

keymap('n', '<leader>lk', ':LookupKanji <c-r><c-w><cr>')
keymap('n', '<leader>lt', ':LookupTerm<cr>')
keymap('n', '<leader>yd', ':YomitanCleanDefinition<cr>')
keymap('n', '<leader>yp', ':YomitanPrepareWords<cr>')
keymap('n', '<leader>yk', ':YomitanCleanKanji<cr>')
keymap('n', '<leader>yj', ':YomitanCleanJisho<cr>')
keymap('n', '<leader>jd', ':<C-U>lua vim.cmd.edit("~/diary/tcj/" .. os.date("%Y_%m_%d") .. ".md")<cr>', { silent = true })
