-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto-save when leaving insert mode and on focus/exit
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "VimLeavePre" }, {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
