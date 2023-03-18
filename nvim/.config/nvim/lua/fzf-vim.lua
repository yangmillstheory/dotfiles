-- This isn't in the after/plugin directory as some variables seem not to
-- be set, e.g. fzf_command_prefix.
--
-- Instead, this module is loaded in the init callback of the plugin manager.
local utils = require('utils')
local g = vim.g

g.fzf_buffers_jump = 1
-- use the same semantics for fzf as in shell
-- keep actions compatible with nerdtree
g.fzf_action = {
  ["ctrl-t"] = 'tab split',
  ["ctrl-i"] = 'split',
  ["ctrl-s"] = 'vsplit',
}
g.fzf_colors = {
  ["fg"] = {'fg', 'Normal'},
  ["bg"] = {'bg', 'Normal'},
  ["hl"] = {'fg', 'Comment'},
  ["fg+"] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
  ["bg+"] = {'bg', 'CursorLine', 'CursorColumn'},
  ["hl+"] = {'fg', 'Statement'},
  ["info"] = {'fg', 'PreProc'},
  ["prompt"] = {'fg', 'Conditional'},
  ["pointer"] = {'fg', 'Exception'},
  ["marker"] = {'fg', 'Keyword'},
  ["spinner"] = {'fg', 'Label'},
  ["header"] = {'fg', 'Comment'},
}
g.fzf_command_prefix = 'Fzf'
g.fzf_layout = {
  window = { width = 0.9, height = 0.9 }
}

g.fzf_preview_window = { 'right,50%,border-sharp' }

-- explicitly allowlist directories
g.fzf_in = {
  'experimental/users/victoralvarez',
  'production/borg/goops',
  'production/borg/cloud-pubsub',
  'configs/monitoring/cloud_pulse_monarch/cloud_pubsub',
  'configs/monitoring/goops',
  'configs/monitoring/cloud_pubsub',
  'configs/production/cdpush/goops',
  'configs/production/cdpush/cloud-pubsub',
}
g.fzf_ex = {
  'assets',
  'fonts',
}

-- quickly edit g.fzf_in
utils.keymap('n', '<leader>d', "q:ilet g:fzf_in=['']<esc>hi")

vim.cmd([[
function! s:FzfDirs(args) abort
  let fzf_args = []
  if len(g:fzf_ex)
    let fzf_args += ["--glob=!{" . join(g:fzf_ex, ",") . "}"]
  endif
  if len(a:args)
    let fzf_args += [a:args]
  endif
  return join(fzf_args + g:fzf_in, " ")
endfunction
command! -bang -complete=dir -nargs=? FzfFiles
\ call fzf#run(fzf#wrap(fzf#vim#with_preview({
\     'source': "rg --files --hidden " . s:FzfDirs(''),
\   })),
\   <bang>0
\ )
command! -bang -nargs=* FzfRg
\ call fzf#vim#grep(
\   "rg --hidden --ignore-case --column --line-number --no-heading --color=always " . s:FzfDirs(<q-args>), 1,
\   <bang>0 ? fzf#vim#with_preview('up:60%')
\           : fzf#vim#with_preview('right:50%'),
\   <bang>0)
]])

local keymap_opts = { silent = true }
utils.keymap('n', '<c-t>', ':FzfFiles<cr>', keymap_opts)
utils.keymap('n', '<c-f>', ':FzfRg<space>', keymap_opts)
utils.keymap('n', '<c-b>', ':FzfBuffers<cr>', keymap_opts)
utils.keymap('n', '<c-_>', ':FzfBLines<cr>', keymap_opts)
utils.keymap('n', '<c-r>', ':FzfHistory:<cr>', keymap_opts)
utils.keymap('n', '<c-s>', ':FzfHistory/<cr>', keymap_opts)
utils.keymap('n', '<c-c>', ':FzfCommands<cr>', keymap_opts)
utils.keymap('n', '<c-q>', ':FzfMarks<cr>', keymap_opts)
