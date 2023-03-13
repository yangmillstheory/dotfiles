require('lualine').setup({
  options = { theme = 'gruvbox' },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 2,
        symbols = {
          modified = '✗',
          readonly = '',
        },
      },
    },
  },
})
