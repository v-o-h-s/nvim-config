return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "html", "css", "scss" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, s in ipairs({ "html", "cssls", "emmet_language_server" }) do
        if not vim.tbl_contains(opts.ensure_installed, s) then
          table.insert(opts.ensure_installed, s)
        end
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = { "html", "htmlangular" },
        },
        cssls = {},
        emmet_language_server = {
          filetypes = {
            "html",
            "htmlangular",
            "css",
            "scss",
            "less",
            "typescriptreact",
            "javascriptreact",
          },
        },
      },
    },
  },
}
