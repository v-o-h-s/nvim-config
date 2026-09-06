return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "angularls") then
        table.insert(opts.ensure_installed, "angularls")
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "angular-language-server") then
        table.insert(opts.ensure_installed, "angular-language-server")
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        angularls = {
          -- angularls declares `typescript`/`typescriptreact` in its filetypes,
          -- so it attaches to every TS project, Angular or not. Its root_markers
          -- (angular.json, nx.json) then find nothing, and Neovim attaches it
          -- anyway in single-file mode with root_dir = nil -- observed on the
          -- Next.js project at ~/Projects/lmimz, where it contributed 0
          -- completion items while still running a full ngserver node process.
          --
          -- Only calling on_dir when a real Angular root exists keeps the server
          -- for actual Angular work and skips it everywhere else.
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if fname == "" then
              return
            end
            local root = vim.fs.root(fname, { "angular.json", "nx.json" })
            if root then
              on_dir(root)
            end
          end,
        },
      },
    },
  },
}
