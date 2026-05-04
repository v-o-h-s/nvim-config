return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim",
  },
  cmd = "Octo",
  event = "VeryLazy",
  config = function()
    require("octo").setup({
      enable_git_status = true,
      default_to_clipboard = true,
      picker = "telescope",
      use_local_fs = true,
    })
  end,
  keys = {
    { "<leader>go", "<cmd>Octo pr list<cr>", desc = "Octo" },
    { "<leader>gpr", "<cmd>Octo pr list<cr>", desc = "PR list" },
    { "<leader>gpc", "<cmd>Octo pr create<cr>", desc = "PR create" },
    { "<leader>gprv", "<cmd>Octo pr review<cr>", desc = "PR review" },
    { "<leader>gpm", "<cmd>Octo pr merge<cr>", desc = "PR merge" },
    { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "Issues" },
    { "<leader>gR", "<cmd>Octo review<cr>", desc = "Review" },
  },
}
