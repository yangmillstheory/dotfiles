vim.opt.list = true
vim.g.indent_blankline_filetype = { "cpp", "python", "lua", "proto" }

require("indent_blankline").setup {
    show_end_of_line = false,
}
