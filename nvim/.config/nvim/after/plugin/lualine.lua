require('lualine').setup({
  options = { theme = 'gruvbox' },
  sections = {
    lualine_b = {
      function ()
        return vim.fn.ObsessionStatus()
      end,
      'diff',
      'diagnostics'
    },
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
