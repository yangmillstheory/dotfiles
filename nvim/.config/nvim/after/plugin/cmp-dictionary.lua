require("cmp_dictionary").setup({
  paths = { "/usr/share/dict/words" },
  exact_length = 2,
  first_case_insensitive = true,
  document = {
    enable = true,
    command = { "wn", "${label}", "-over" },
  },
})
