return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, s in ipairs({ "tailwindcss" }) do
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
        tailwindcss = {
          filetypes_include = { "htmlangular" },
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className", "ngClass", "class:list" },
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  'tw\\("([^"]*)"\\)',
                  "tw\\(([^)]*)\\)",
                  "clsx\\(([^)]*)\\)",
                  "cn\\(([^)]*)\\)",
                },
              },
            },
          },
        },
      },
    },
  },
}
