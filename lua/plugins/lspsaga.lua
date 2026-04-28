return {
  "glepnir/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("lspsaga").setup({
      ui = {
        border = "rounded",
        title = true,
        winblend = 0,
        expand = "",
        collapse = "",
        preview = "",
        code_action = "💡",
        actionfix = "",
        kind = {},
      },
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
      scroll_preview = {
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
      definition = {
        keys = {
          edit = "<C-cr>",
          vsplit = "<C-v>",
          split = "<C-s>",
          tabe = "<C-t>",
          quit = "q",
          close = "<Esc>",
        },
      },
      outline = {
        win_position = "right",
        win_width = 30,
      },
    })

    local keymap = vim.keymap.set

    -- Peek definition (opens in floating popup)
    keymap("n", "gK", "<Cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })

    -- Hover documentation
    keymap("n", "K", "<Cmd>Lspsaga hover_doc<CR>", { desc = "Hover documentation" })

    -- Show references in side panel
    keymap("n", "gr", "<Cmd>Lspsaga finder<CR>", { desc = "References" })

    -- Code actions
    keymap({ "n", "v" }, "<leader>ca", "<Cmd>Lspsaga code_action<CR>", { desc = "Code action" })

    -- Rename
    keymap("n", "<leader>rn", "<Cmd>Lspsaga rename<CR>", { desc = "Rename" })

    -- Show outline
    keymap("n", "<leader>o", "<Cmd>Lspsaga outline<CR>", { desc = "Outline" })

    -- Scroll in hover/definition preview
    keymap("n", "<C-f>", "<Cmd>Lspsaga scroll_preview<CR>", { desc = "Scroll preview forward" })
    keymap("n", "<C-b>", "<Cmd>Lspsaga scroll_back<CR>", { desc = "Scroll preview back" })
  end,
}
