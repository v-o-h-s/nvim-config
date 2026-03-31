return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>",      desc = "Toggle terminal" },
      { "<leader>tf",  desc = "Float terminal" },
      { "<leader>th",  desc = "Horizontal terminal" },
      { "<leader>tv",  desc = "Vertical terminal" },
      { "<leader>tg",  desc = "Lazygit terminal" },
      { "<leader>tn",  desc = "Node terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.85),
        height = math.floor(vim.o.lines * 0.8),
        winblend = 10,
        title_pos = "center",
      },
      winbar = {
        enabled = false,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = { border = "curved" },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      -- Node REPL
      local node = Terminal:new({ cmd = "node", direction = "horizontal" })

      -- Keymaps
      vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",      { desc = "Float terminal" })
      vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
      vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",   { desc = "Vertical terminal" })
      vim.keymap.set("n", "<leader>tg", function() lazygit:toggle() end,            { desc = "Lazygit" })
      vim.keymap.set("n", "<leader>tn", function() node:toggle() end,               { desc = "Node REPL" })

      -- Easy escape from terminal mode
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], { desc = "Move to left window" })
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], { desc = "Move to below window" })
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], { desc = "Move to above window" })
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], { desc = "Move to right window" })
    end,
  },
}
