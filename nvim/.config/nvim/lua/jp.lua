vim.api.nvim_create_user_command('YomitanRmNums',
-- TODO: <span> and other HTML tags can mess this up?
  function(_)
    -- Strip out tags like (\d+).
    vim.cmd([[silent! %s/\v\(\d+\)//g]])
    -- Strip out tags like (1, \w+).
    vim.cmd([[silent! %s/\v\(\d+,\s([^)]+)\)/(\1)/g]])
    -- Yank into the system clipboard.
    vim.cmd.normal('"*yy')
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
    -- Yank into the system clipboard.
    vim.cmd.normal('"*yy')
  end
, {
  desc = 'Make Yomitan-mined Kanji not be HTML lists, but plain text separated by |.'
})


