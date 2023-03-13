local g = vim.g
g.tmuxline_status_justify = 'left'
g.tmuxline_theme = 'lightline'
g.tmuxline_preset = {
  a = '#S',
  b = {
    '#(compact-path #{pane_current_path})',
    '#[italics,nobold]#{pane_current_command}',
  },
  win = {'#I', '#W' },
  cwin = { '#I', '#W' },
  y = { '#[bold]%I:%M %p (%Z)', '#[bold]%a %b %d' },
  z = '#h'
}
