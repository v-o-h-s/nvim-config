return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",            desc = "Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>",           desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",            desc = "Delete Buffers to the Left" },
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "[B",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move Buffer Left" },
      { "]B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move Buffer Right" },
    },
    opts = {
      options = {
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warn = " ", hint = " ", info = " " }
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
            .. (diag.warning and icons.warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
      highlights = {
        -- Glassmorphism: transparent bar, white chip for the active buffer
        fill = { bg = "NONE" },
        background = { bg = "NONE", fg = "#7b8496" },
        tab = { bg = "NONE", fg = "#7b8496" },
        tab_selected = { bg = "#ffffff", fg = "#16181a", bold = true },
        buffer_visible = { bg = "NONE", fg = "#b0b8c5" },
        buffer_selected = {
          bg = "#ffffff",
          fg = "#16181a",
          bold = true,
          italic = false,
        },
        indicator_selected = { fg = "#ffffff", bg = "#ffffff" },
        separator = { fg = "#3c4048", bg = "NONE" },
        separator_selected = { fg = "#3c4048", bg = "#ffffff" },
        separator_visible = { fg = "#3c4048", bg = "NONE" },
        close_button = { bg = "NONE", fg = "#7b8496" },
        close_button_selected = { bg = "#ffffff", fg = "#16181a" },
        modified = { bg = "NONE", fg = "#ffbd5e" },
        modified_selected = { bg = "#ffffff", fg = "#9a6b00" },
        diagnostic = { bg = "NONE" },
        diagnostic_selected = { bg = "#ffffff" },
        error = { bg = "NONE", fg = "#ff6e5e" },
        error_selected = { bg = "#ffffff", fg = "#c0392b", bold = true },
        warning = { bg = "NONE", fg = "#ffbd5e" },
        warning_selected = { bg = "#ffffff", fg = "#9a6b00", bold = true },
        info = { bg = "NONE", fg = "#b0b8c5" },
        info_selected = { bg = "#ffffff", fg = "#2c5f8a", bold = true },
        hint = { bg = "NONE", fg = "#b0b8c5" },
        hint_selected = { bg = "#ffffff", fg = "#2e7d6b", bold = true },
        pick = { bg = "NONE", fg = "#ffffff", bold = true },
        pick_selected = { bg = "#ffffff", fg = "#16181a", bold = true },
        offset_separator = { bg = "NONE", fg = "#3c4048" },
      },
    },
  },
}
