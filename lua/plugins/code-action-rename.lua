-- ── Code actions + "Rename symbol" in one menu ────
-- LSP rename already updates every occurrence project-wide; this surfaces it
-- inside the code-action picker instead of needing a separate rename binding.
--
-- Two implementation notes:
--
-- 1. We issue the codeAction request ourselves rather than wrapping
--    vim.lsp.buf.code_action(): the builtin bails out with "No code actions
--    available" *before* opening any picker when the server returns nothing,
--    which is exactly when you still want the rename entry.
--
-- 2. It's registered through nvim-lspconfig's `servers["*"].keys` — LazyVim's
--    own supported hook — rather than an LspAttach autocmd. LazyVim installs
--    its buffer-local <leader>ca late enough to clobber an autocmd-set map
--    (even a scheduled one); going through its keymap list avoids that race.
--
-- Bound to <leader>ca, not `gra`: LazyVim maps buffer-local `gr` -> References
-- with nowait=true, so `gr` fires instantly and no `gr_` sequence is reachable.

local function code_action_with_rename()
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local lnum = vim.api.nvim_win_get_cursor(win)[1] - 1

  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
  if not next(clients) then
    vim.notify("No LSP client supporting code actions", vim.log.levels.WARN)
    return
  end

  vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", function(client)
    local params = vim.lsp.util.make_range_params(win, client.offset_encoding)
    params.context = {
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
      diagnostics = vim.lsp.diagnostic.from(vim.diagnostic.get(bufnr, { lnum = lnum })),
    }
    return params
  end, function(results)
    -- snacks' picker ignores format_item for kind="codeaction" and reads
    -- item.action.title / item.ctx.client_id directly, so the rename entry has
    -- to carry that shape too or the picker errors out. client_id = -1 resolves
    -- to no client, which just means no "[server]" suffix gets appended.
    local items = {
      {
        rename = true,
        action = { title = "Rename symbol (all occurrences)" },
        ctx = { client_id = -1, bufnr = bufnr },
      },
    }
    for client_id, res in pairs(results or {}) do
      for _, action in pairs(res.result or {}) do
        table.insert(items, { action = action, ctx = { client_id = client_id, bufnr = bufnr } })
      end
    end

    vim.ui.select(items, {
      prompt = "Code actions:",
      kind = "codeaction",
      format_item = function(item)
        if item.rename then
          return "Rename symbol (all occurrences)"
        end
        local title = item.action.title:gsub("\r?\n", " ")
        if item.action.disabled then
          title = title .. " (disabled)"
        end
        return #clients > 1
            and ("%s [%s]"):format(title, vim.lsp.get_client_by_id(item.ctx.client_id).name)
          or title
      end,
    }, function(choice)
      if not choice then
        return
      end
      if choice.rename then
        vim.lsp.buf.rename()
        return
      end

      local client = vim.lsp.get_client_by_id(choice.ctx.client_id)
      if not client then
        return
      end
      local action = choice.action
      if action.disabled then
        vim.notify(action.disabled.reason, vim.log.levels.ERROR)
        return
      end

      local function apply(a)
        if a.edit then
          vim.lsp.util.apply_workspace_edit(a.edit, client.offset_encoding)
        end
        if a.command then
          client:exec_cmd(type(a.command) == "table" and a.command or a, choice.ctx)
        end
      end

      -- A bare Command (title+command both strings) is applied as-is.
      if type(action.title) == "string" and type(action.command) == "string" then
        apply(action)
        return
      end
      -- Otherwise resolve first, so lazily-computed edits are filled in.
      if not (action.edit and action.command) and client:supports_method("codeAction/resolve") then
        client:request("codeAction/resolve", action, function(err, resolved)
          if err then
            if action.edit or action.command then
              apply(action)
            else
              vim.notify(tostring(err.message), vim.log.levels.ERROR)
            end
          else
            apply(resolved)
          end
        end, bufnr)
      else
        apply(action)
      end
    end)
  end)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "<leader>ca",
              code_action_with_rename,
              desc = "Code Action (+ rename)",
              has = "codeAction",
            },
          },
        },
      },
    },
  },
}
