-- Jupyter notebooks via ipynb.nvim: native .ipynb editing (no jupytext
-- conversion), notebook-style UI with isolated cell buffers, kernel
-- execution, kitty image output, LSP through a shadow buffer.
-- Previous molten+jupytext stack kept in notebook.lua.molten-backup;
-- restore by swapping the filenames back.
--
-- Default keys (see :h ipynb):
--   ]] / [[            next / previous cell
--   i or <CR>          edit cell   |   <Esc>  back to notebook mode
--   <S-CR>             run cell and go to next (Jupyter-style)
--   <C-CR>             run cell and stay
--   dd / p / P         cut / paste cells
--   <leader>ks         start kernel
--   <leader>kh / kv    inspect variable / all cell variables

return {
  {
    "ajbucci/ipynb.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    -- Must load at startup: the plugin takes over .ipynb reads via BufReadCmd,
    -- which Neovim checks before any lazy-load event fires. Loading it lazily
    -- means the first .ipynb opens as raw JSON (and risks corruption on save).
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("ipynb").setup(opts)
      -- d2l-en ships 0-byte .ipynb placeholders; upstream read_ipynb crashes
      -- on empty JSON, so treat an empty file as a fresh notebook instead.
      local io_mod = require("ipynb.io")
      local orig_read = io_mod.read_ipynb
      io_mod.read_ipynb = function(path)
        local stat = vim.uv.fs_stat(path)
        if stat and stat.size == 0 then
          return io_mod.create_empty_notebook()
        end
        return orig_read(path)
      end
    end,
  },

  -- Prose rendering for markdown files AND notebook markdown cells: the ipynb
  -- treesitter parser injects markdown into markdown cells, so adding "ipynb"
  -- to file_types makes render-markdown decorate headings/lists/links there.
  -- LaTeX ($..$ / $$..$$) renders as readable unicode via the latex treesitter
  -- parser + the latex2text executable (pylatexenc, in ~/.local/bin).
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- LazyVim's markdown extra lazy-loads this on ft=markdown only; add ipynb
    -- so it also loads for notebook buffers (ft lists from both specs merge)
    ft = { "markdown", "ipynb" },
    opts = {
      file_types = { "markdown", "ipynb" },
      latex = { enabled = true },
    },
  },
}
