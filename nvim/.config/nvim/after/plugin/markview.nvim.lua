local markview = require("markview");
local presets = require("markview.presets");

markview.setup({
  headings = presets.headings.glow_labels,
  list_items = {
    enable = true,
    shift_width = 2,
    indent_size = 2,
  },
});

vim.cmd("Markview enableAll");
