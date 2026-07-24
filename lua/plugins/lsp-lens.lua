return {
  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable = true,
      include_declaration = false,
      sections = {
        definition = false,
        references = true,
        implements = true,
        git_authors = false,
      },
    },
    config = function(_, opts)
      require("lsp-lens").setup(opts)

      -- The plugin recomputes on every LspAttach/TextChanged/BufEnter with
      -- no debounce, so right as you finish an edit it can fire before the
      -- LSP has reparsed and briefly show 0/blank counts. Swap its autocmd
      -- for a debounced one (per-buffer) so it waits for typing to settle.
      local lens = require("lsp-lens.lens-util")
      local augroup = vim.api.nvim_create_augroup("lsp_lens", { clear = true })
      local timers = {}
      vim.api.nvim_create_autocmd({ "LspAttach", "TextChanged", "BufEnter" }, {
        group = augroup,
        callback = function(args)
          local buf = args.buf
          if timers[buf] then
            timers[buf]:stop()
          end
          timers[buf] = vim.defer_fn(function()
            timers[buf] = nil
            lens.procedure(args)
          end, 400)
        end,
      })
    end,
  },
}
