return {
  {
    "marcinjahn/gemini-cli.nvim",
    cmd = "Gemini",
    keys = {
      { "<leader>ait", "<cmd>Gemini toggle<cr>",     desc = "Toggle Gemini CLI" },
      { "<leader>aia", "<cmd>Gemini ask<cr>",         desc = "Ask Gemini", mode = { "n", "v" } },
      { "<leader>aif", "<cmd>Gemini add_file<cr>",    desc = "Add File to Gemini" },
      { "<leader>aid", "<cmd>Gemini diagnostics<cr>", desc = "Send Diagnostics to Gemini" },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
    config = true,
  },
}
