-- Floating popup terminal via snacks.nvim (already bundled with LazyVim).
-- <A-t> works in both normal and terminal mode, so the same key hides the
-- terminal again from inside it.
local function float_term()
  Snacks.terminal.toggle(nil, {
    win = { position = "float", border = "rounded", width = 0.85, height = 0.8 },
  })
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<A-t>", float_term, mode = { "n", "t" }, desc = "Terminal (float)" },
    },
  },
}
