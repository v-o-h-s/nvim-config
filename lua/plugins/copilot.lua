return {
  -- Copilot.lua: ghost text AI completions
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",         -- Alt+L: accept full suggestion
          accept_word = "<M-Right>", -- Alt+Right: accept one word
          accept_line = "<M-Tab>",   -- Alt+Tab: accept one line
          next = "<M-]>",            -- Alt+]: next suggestion
          prev = "<M-[>",            -- Alt+[: prev suggestion
          dismiss = "<C-e>",         -- Ctrl+E: dismiss
        },
      },
      panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "right",
          ratio = 0.4,
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        ["."] = true,
      },
    },
  },

  -- blink-copilot: feeds Copilot into blink.cmp popup
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = false,
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
  },

  -- Wire blink-copilot into blink.cmp
  {
    "saghen/blink.cmp",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
