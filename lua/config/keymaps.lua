-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ── Tab management ────
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tl", ":tabn<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>th", ":tabp<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tmh", ":-tabmove<CR>", { desc = "Move tab left" })
vim.keymap.set("n", "<leader>tml", ":+tabmove<CR>", { desc = "Move tab right" })

-- ── Octo.nvim ────
vim.keymap.set("n", "<leader>go", "<cmd>Octo<CR>", { desc = "Octo dashboard" })
vim.keymap.set("n", "<leader>gpr", "<cmd>Octo pr list<CR>", { desc = "List PRs" })
vim.keymap.set("n", "<leader>gpc", "<cmd>Octo pr create<CR>", { desc = "Create PR" })
vim.keymap.set("n", "<leader>gprv", "<cmd>Octo pr review<CR>", { desc = "Review PR" })
vim.keymap.set("n", "<leader>gpm", "<cmd>Octo pr merge<CR>", { desc = "Merge PR" })
vim.keymap.set("n", "<leader>gi", "<cmd>Octo issue list<CR>", { desc = "List issues" })
vim.keymap.set("n", "<leader>gR", "<cmd>Octo review<CR>", { desc = "Start review" })

-- ── Resize splits (works for explorer and opencode panels) ────
-- Move cursor to the panel first with Ctrl+h/l, then use these
vim.keymap.set("n", "<A-Left>",  "<C-w>5<", { desc = "Shrink window width" })
vim.keymap.set("n", "<A-Right>", "<C-w>5>", { desc = "Grow window width" })
vim.keymap.set("n", "<A-Up>",    "<C-w>5+", { desc = "Grow window height" })
vim.keymap.set("n", "<A-Down>",  "<C-w>5-", { desc = "Shrink window height" })

-- ── Run C++ file ────
vim.keymap.set("n", "<leader>cr", function()
  local file = vim.fn.expand("%:p")
  local out = vim.fn.expand("%:p:r")
  vim.cmd("vsplit | terminal g++ -std=c++17 -Wall -o '" .. out .. "' '" .. file .. "' && '" .. out .. "'")
end, { desc = "Compile and run C++" })


