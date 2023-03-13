require('lualine').setup({
  options = { theme = 'gruvbox' },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = '✗',
          readonly = '',
        },
      },
    },
  },
})
