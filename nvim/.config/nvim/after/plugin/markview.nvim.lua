local markview = require("markview");
local presets = require("markview.presets");

markview.setup({
  headings = presets.headings.glow_labels,
  list_items = {
    enable = true,
    shift_width = 2,
    indent_size = 2,
  },

  modes = { "n", "no", "c" },
  hybrid_modes = { "n" },
  callbacks = {
    on_enable = function (_, win)
      vim.wo[win].conceallevel = 2;
      vim.wo[win].concealcursor = "c";
    end
  }
});

vim.cmd("Markview enableAll");
