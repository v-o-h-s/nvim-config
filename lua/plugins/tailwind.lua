return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "tailwindcss") then
        table.insert(opts.ensure_installed, "tailwindcss")
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tailwindcss = opts.servers.tailwindcss or {}

      local tw = opts.servers.tailwindcss
      tw.filetypes = tw.filetypes
        or {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
          "astro",
        }

      tw.settings = tw.settings or {}
      tw.settings.tailwindCSS = tw.settings.tailwindCSS or {}
      tw.settings.tailwindCSS.classAttributes = { "class", "className", "ngClass", "class:list" }
      tw.settings.tailwindCSS.experimental = {
        classRegex = {
          "tw`([^`]*)",
          "tw\\(([^)]*)\\)",
          "clsx\\(([^)]*)\\)",
          "cn\\(([^)]*)\\)",
        },
      }
    end,
  },
}
