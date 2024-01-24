vim.api.nvim_create_user_command('YomitanRmNums',
  function(_)
    -- Strip out tags like (\d+).
    vim.cmd([[%s/\v\(\d+\)\s//g]])
    -- Strip out tags like (1, \w+).
    vim.cmd([[%s/\v\(\d+,\s(.+)\)/(\1)/g]])
    -- TODO: <span> tags can mess this up?
  end
, {
  desc = 'Remove redundant numerical meaning tags like (1), (2), from mined Yomitan HTML definitions.'
})

vim.api.nvim_create_user_command('YomitanCleanKanjiDef',
  function(_)
    -- Strip beginning and ending HTML tags.
    vim.cmd.normal('0')
    vim.cmd.normal('3df>')
    vim.cmd.normal('$')
    vim.cmd.normal('3dF<x')
    -- Replace interior </li><li> (etc) tags with |.
    vim.cmd([[%s/\v(\<\/?[oli]{2}\>){2}/ | /g]])
  end
, {
  desc = 'Make Yomitan-mined Kanji not be HTML lists, but plain text separated by |.'
})


