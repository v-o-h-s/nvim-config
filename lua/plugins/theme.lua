return {
  -- ── Rose Pine — glassmorphism base ─────────────────────────
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "moon",
      dark_variant = "moon",
      dim_inactive_windows = false,
      styles = {
        bold = true,
        italic = false,
        transparency = true, -- kitty's frosted background shows through
      },
    },
    init = function()
      -- Glass polish on top of any colorscheme
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("glass_ui", { clear = true }),
        callback = function()
          local hl = vim.api.nvim_set_hl
          -- Floats: transparent with soft white borders
          hl(0, "NormalFloat", { bg = "NONE" })
          hl(0, "FloatBorder", { fg = "#b0b8c5", bg = "NONE" })
          hl(0, "FloatTitle", { fg = "#ffffff", bg = "NONE", bold = true })
          hl(0, "WinSeparator", { fg = "#3c4048", bg = "NONE" })
          -- Popup menu: solid for readability, white chip selection
          hl(0, "Pmenu", { bg = "#1e2124", fg = "#b0b8c5" })
          hl(0, "PmenuSel", { bg = "#ffffff", fg = "#16181a", bold = true })
          hl(0, "PmenuSbar", { bg = "#1e2124" })
          hl(0, "PmenuThumb", { bg = "#515763" })
          -- Editor chrome
          hl(0, "CursorLine", { bg = "#393a3c" }) -- ~15% white wash, glass highlight
          hl(0, "LineNr", { fg = "#515763", bg = "NONE" })
          hl(0, "CursorLineNr", { fg = "#ffffff", bg = "NONE", bold = true })
          hl(0, "SignColumn", { bg = "NONE" })
          -- lsp-lens virtual text (reference/implementation counts): white-grey
          hl(0, "LspLens", { fg = "#c8c8c8", bg = "NONE", italic = false })
          -- Pickers (telescope / snacks) follow the float glass look
          hl(0, "TelescopeBorder", { fg = "#b0b8c5", bg = "NONE" })
          hl(0, "TelescopeNormal", { bg = "NONE" })
          hl(0, "SnacksPickerBorder", { fg = "#b0b8c5", bg = "NONE" })
          hl(0, "SnacksNormal", { bg = "NONE" })
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
