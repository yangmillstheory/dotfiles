vim.g.startify_custom_header = {
"        _                     _             _   _  __",
"       (_)                   | |           | | (_)/ _|",
" __   ___ _ __ ___ ______ ___| |_ __ _ _ __| |_ _| |_ _   _",
[[ \ \ / / | '_ ` _ \______/ __| __/ _` | '__| __| |  _| | | |]],
[[  \ V /| | | | | | |     \__ \ || (_| | |  | |_| | | | |_| |]],
[[   \_/ |_|_| |_| |_|     |___/\__\__,_|_|   \__|_|_|  \__, |]],
"                                                       __/ |",
"                                                      |___/",
}
vim.g.startify_files_number = 5
vim.g.startify_enable_special = 0
vim.g.startify_session_persistence = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_change_to_dir = 0
vim.g.startify_session_sort = 1

vim.g.startify_lists = {
  { type = 'sessions', header = { 'Sessions' } },
  { type = 'bookmarks', header = { 'Bookmarks' } },
}

function G3Root(workspace)
  return '/google/src/cloud/victoralvarez/' .. workspace .. '/google3/'
end

function OncallFile(filename)
  return G3Root('pubsub-oncall') .. 'configs/production/oncall/configs/' .. filename
end

vim.g.startify_bookmarks = {
  OncallFile('oncall.pubsub-sre-zrh'),
  OncallFile('oncall.pubsub-tickets'),
  OncallFile('oncall.pubsub-customer-tickets'),
  '~/code/dotfiles',
}
