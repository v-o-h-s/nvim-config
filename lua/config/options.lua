-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto-save: immediate on InsertLeave/FocusLost/BufLeave/exit, debounced while
-- typing. A write per keystroke (the old behavior) also ran format-on-save and
-- LSP didSave handlers on every single change, which made editing sluggish.
local autosave = vim.api.nvim_create_augroup("buffer_autosave", { clear = true })
local autosave_timers = {}

local function autosave_write(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if
    vim.bo[buf].modified
    and vim.bo[buf].buftype == ""
    and vim.bo[buf].modifiable
    and not vim.bo[buf].readonly
    and vim.api.nvim_buf_get_name(buf) ~= ""
  then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! write")
    end)
  end
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = autosave,
  callback = function(args)
    local buf = args.buf
    if not autosave_timers[buf] then
      autosave_timers[buf] = vim.uv.new_timer()
    end
    autosave_timers[buf]:start(
      1500,
      0,
      vim.schedule_wrap(function()
        -- still in insert mode: skip, InsertLeave saves immediately anyway
        if vim.api.nvim_get_mode().mode:find("^i") then
          return
        end
        autosave_write(buf)
      end)
    )
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
  group = autosave,
  callback = function(args)
    autosave_write(args.buf)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = autosave,
  callback = function()
    vim.cmd("silent! wall")
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  group = autosave,
  callback = function(args)
    local t = autosave_timers[args.buf]
    if t then
      t:stop()
      t:close()
      autosave_timers[args.buf] = nil
    end
  end,
})

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

vim.opt.scrollback = 100000

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
-- Python provider: dedicated venv (pynvim, jupyter_client, jupytext) for molten/notebooks
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/neovim/bin/python")
