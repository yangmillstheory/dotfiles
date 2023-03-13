local lsp = require('lspconfig')
local lsp_configs = require('lspconfig.configs')

lsp_configs.ciderlsp = {
    default_config = {
        cmd = { '/google/bin/releases/cider/ciderlsp/ciderlsp', '--tooltag=nvim-lsp', '--noforward_sync_responses' };
        filetypes = { 'c', 'cpp', 'java', 'kotlin', 'objc', 'proto', 'textproto', 'go', 'python', 'bzl' },
        root_dir = lsp.util.root_pattern('BUILD');
        settings = {};
    }
}

lsp.ciderlsp.setup({})
