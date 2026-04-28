-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto-save on any buffer change (insert or normal mode)
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave", "FocusLost", "VimLeavePre" }, {
  group = vim.api.nvim_create_augroup("opencode_autosave", { clear = true }),
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    if vim.bo[buf].modified and vim.bo[buf].buftype == "" and vim.bo[buf].modifiable and not vim.bo[buf].readonly then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        vim.cmd("silent! write")
      end
    end
  end,
})

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
