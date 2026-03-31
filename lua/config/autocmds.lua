-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Auto-reload when returning to Neovim or after terminal commands
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("opencode_autoread", { clear = true }),
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- PDF helper: open current PDF in an external viewer
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("pdf_viewer_keymap", { clear = true }),
  pattern = "pdf",
  callback = function(event)
    vim.keymap.set("n", "<leader>pv", function()
      local file = vim.fn.expand("%:p")
      if vim.fn.executable("zathura") == 1 then
        vim.fn.jobstart({ "zathura", file }, { detach = true })
      elseif vim.fn.executable("evince") == 1 then
        vim.fn.jobstart({ "evince", file }, { detach = true })
      else
        vim.notify("Install a PDF viewer (zathura/evince) to open PDFs", vim.log.levels.WARN)
      end
    end, { buffer = event.buf, desc = "Open PDF in viewer" })
  end,
})
