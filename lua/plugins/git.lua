return {
  -- Neogit integration (Magit clone)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- optional - for diffs
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
    },
  },

  -- Git signs in the gutter (shows added/changed/removed lines)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      attach_to_untracked = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        -- Navigation
        vim.keymap.set("n", "]h", gs.next_hunk,   { buffer = buffer, desc = "Next hunk" })
        vim.keymap.set("n", "[h", gs.prev_hunk,   { buffer = buffer, desc = "Prev hunk" })

        -- Actions
        vim.keymap.set("n", "<leader>gp", gs.preview_hunk,         { buffer = buffer, desc = "Preview hunk" })
        vim.keymap.set("n", "<leader>gb", gs.blame_line,           { buffer = buffer, desc = "Blame line" })
        vim.keymap.set("n", "<leader>gd", gs.diffthis,             { buffer = buffer, desc = "Diff this file" })
        vim.keymap.set("n", "<leader>gs", gs.stage_hunk,           { buffer = buffer, desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>gr", gs.reset_hunk,           { buffer = buffer, desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>gB", function() gs.blame_line({ full = true }) end, { buffer = buffer, desc = "Blame line (full)" })

      end,
    },
  },
}
