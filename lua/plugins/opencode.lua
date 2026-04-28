local function set_opencode_highlights()
  local p = {
    base = "#1e1e2e",
    mantle = "#181825",
    surface0 = "#313244",
    surface1 = "#45475a",
    text = "#cdd6f4",
    subtext = "#a6adc8",
    blue = "#89b4fa",
    green = "#a6e3a1",
    yellow = "#f9e2af",
    red = "#f38ba8",
    peach = "#fab387",
    mauve = "#cba6f7",
    teal = "#94e2d5",
  }

  local set = vim.api.nvim_set_hl
  set(0, "OpencodeBackground", { fg = p.text, bg = p.base })
  set(0, "OpencodeBorder", { fg = p.surface1, bg = p.base })
  set(0, "OpencodeToolBorder", { fg = p.surface1, bg = p.base, nocombine = true })
  set(0, "OpencodeSessionDescription", { fg = p.subtext, italic = true })
  set(0, "OpencodeMessageRoleAssistant", { fg = p.blue, bold = true })
  set(0, "OpencodeMessageRoleUser", { fg = p.green, bold = true })
  set(0, "OpencodeInputLegend", { fg = p.subtext, bg = p.mantle })
  set(0, "OpencodeContextBar", { fg = p.subtext })
  set(0, "OpencodeContextFile", { fg = p.teal })
  set(0, "OpencodeContextSelection", { fg = p.mauve })
  set(0, "OpencodeContextWarning", { fg = p.yellow })
  set(0, "OpencodeContextError", { fg = p.red })
  set(0, "OpencodeContextInfo", { fg = p.blue })
  set(0, "OpencodeDiffAdd", { bg = "#263230" })
  set(0, "OpencodeDiffDelete", { bg = "#3b242f" })
  set(0, "OpencodeDiffGutter", { fg = p.subtext, bg = p.mantle })
  set(0, "OpencodeDiffAddGutter", { fg = p.green, bg = "#263230" })
  set(0, "OpencodeDiffDeleteGutter", { fg = p.red, bg = "#3b242f" })
  set(0, "OpencodeAgentBuild", { fg = p.base, bg = p.blue, bold = true })
  set(0, "OpencodeAgentPlan", { fg = p.base, bg = p.mauve, bold = true })
  set(0, "OpencodeAgentCustom", { fg = p.base, bg = p.teal, bold = true })
  set(0, "OpencodeVariant", { fg = p.peach, bold = true })
  set(0, "OpencodeReference", { fg = p.blue, underline = true })
  set(0, "OpencodePermissionTitle", { fg = p.peach, bold = true })
end

return {
  {
    "sudo-tee/opencode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode_output" },
          latex = { enabled = false },
        },
        ft = { "markdown", "opencode_output" },
      },
      -- Optional, for file mentions picker (you already have snacks)
      "folke/snacks.nvim",
    },
    config = function()
      set_opencode_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("opencode_theme", { clear = true }),
        callback = set_opencode_highlights,
      })

      require("opencode").setup({
        preferred_picker = "snacks",
        preferred_completion = "vim_complete",
        default_global_keymaps = true,
        keymap_prefix = "<leader>o",
        ui = {
          enable_treesitter_markdown = true,
          window_highlight = "Normal:OpencodeBackground,NormalFloat:OpencodeBackground,FloatBorder:OpencodeBorder",
          icons = {
            preset = "nerdfonts",
            overrides = {},
          },
          highlights = {
            vertical_borders = {
              user = { fg = "#a6e3a1", bg = "#1e1e2e" },
              assistant = { fg = "#89b4fa", bg = "#1e1e2e" },
              tool = { fg = "#f9e2af", bg = "#1e1e2e" },
            },
          },
          display_model = true,
          display_context_size = true,
          display_cost = true,
          output = {
            tools = {
              show_output = true,
              show_reasoning_output = false,
            },
            rendering = {
              markdown_debounce_ms = 600,
              event_throttle_ms = 120,
              event_collapsing = true,
            },
          },
          input = {
            text = {
              wrap = true,
            },
          },
        },
        context = {
          diagnostics = {
            enabled = false,
          },
        },
        logging = {
          enabled = true,
          level = "warn",
          outfile = vim.fn.stdpath("log") .. "/opencode.log",
        },
        keymap = {
          editor = {
            ["<leader>om"] = { "switch_mode", desc = "Switch agent mode (build/plan)" },
            ["<leader>od"] = { "diff_open", desc = "Diff since last prompt" },
          },
        },
      })
    end,
  },
}