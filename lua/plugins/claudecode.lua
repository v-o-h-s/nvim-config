return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        diff_opts = {
          layout = "vertical", -- side-by-side diff split
          open_in_new_tab = true, -- open the diff in its own tab
          keep_terminal_focus = false, -- focus the diff, not the Claude terminal
          hide_terminal_in_new_tab = false, -- show Claude terminal in the new tab too
          on_new_file_reject = "close_window", -- close placeholder window on reject
          auto_resize_terminal = true, -- auto-resize Claude terminal when opening diffs
        },
        -- Let the cursor reach the very top/bottom edge of the Claude terminal
        -- window. With the default scrolloff (4) the cursor "stops" a few lines
        -- short and the view feels stuck; 0 makes scrolling reveal text smoothly.
        snacks_win_opts = {
          wo = { scrolloff = 0 },
        },
      })

      -- Enter Normal (scroll) mode from the Claude terminal. Keeps the existing
      -- <C-s>, and Snacks also gives you double-<Esc>.
      vim.keymap.set("t", "<C-s>", "<C-\\><C-n>", { desc = "Exit terminal mode (scroll mode)" })

      -- Scroll keys + big scrollback, scoped to Snacks terminals (which is what
      -- the Claude window is) instead of every terminal buffer.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "snacks_terminal",
        callback = function(ev)
          vim.bo[ev.buf].scrollback = 100000
          local opts = { buffer = ev.buf, silent = true }
          -- One keypress to read history: <PageUp> leaves insert mode AND pages
          -- up, so you don't have to know the modal dance. From there keep
          -- pressing PageUp/PageDown (or <C-u>/<C-d>); press i to chat again.
          vim.keymap.set("t", "<PageUp>", "<C-\\><C-n><C-b>", vim.tbl_extend("force", opts, { desc = "Claude: scroll up" }))
        end,
      })
    end,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
    },
  },
}
