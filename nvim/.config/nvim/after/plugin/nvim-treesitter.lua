require('tree-sitter-cpp-google').setup()
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'cpp', 'lua', 'vim', 'go', 'python'},
  highlight = {
    enable = true,
    disable = function(_, buf)
      local bufname = vim.api.nvim_buf_get_name(buf)
      local protosuffix = '.proto.h'
      if bufname:sub(-#protosuffix) == protosuffix then
        return true
      end
      local max_filesize = 1000 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
          return true
      end
      return false
    end
  }
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
