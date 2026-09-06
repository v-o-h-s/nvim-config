-- Kept from a latency investigation on this 400MHz-clamped machine.
--
-- Context for anyone (including future me) tempted to add more here: almost
-- nothing measurable was found. Treesitter, LSP folds, indentexpr, diagnostics,
-- lualine and nvim-ts-autotag were each retested by toggling them back-to-back
-- inside one nvim session, which cancels the ~2.7x run-to-run drift this CPU
-- shows. Treesitter came out at ~5% and folds at ~0%. An earlier single-shot
-- ablation claimed 40% and 16% for those two; that was noise. Typing cost here
-- is the CPU clamp, not the config.
--
-- Disabling snacks `words` (word-under-cursor highlighting) was tried and
-- reverted: it costs an LSP documentHighlight per cursor move, but no
-- measurable typing gain was ever demonstrated for removing it, and the
-- highlight is wanted.
return {
  {
    "saghen/blink.cmp",
    init = function()
      -- When you type `object.`, blink issues the LSP request and then draws
      -- nothing at all until the items come back -- measured at ~400ms on a
      -- small file, worse on real ones. It *has* a "Loading..." menu for
      -- exactly this, but completion/init.lua arms it only for
      -- `trigger.kind == 'manual'` (an explicit <C-Space>), so an automatic
      -- trigger character never shows it.
      --
      -- Arm the same loading menu for automatic triggers too, on a shorter
      -- fuse. This does not make tsserver any faster; it replaces a silent
      -- gap with visible feedback, which is the part that reads as "stuck".
      vim.api.nvim_create_autocmd("InsertEnter", {
        group = vim.api.nvim_create_augroup("blink_loading_hint", { clear = true }),
        once = true,
        callback = function()
          vim.schedule(function()
            local ok_t, trigger = pcall(require, "blink.cmp.completion.trigger")
            local ok_l, list = pcall(require, "blink.cmp.completion.list")
            local ok_m, menu = pcall(require, "blink.cmp.completion.windows.menu")
            if not (ok_t and ok_l and ok_m) then
              return
            end
            local timer = vim.uv.new_timer()
            -- pending = a trigger fired and no real items have been shown yet
            local pending = false
            -- Safety: if a request never produces items, `pending` must not
            -- re-arm the loading menu forever. Give it a deadline and a exit.
            local deadline = 0

            local function arm(ctx)
              timer:stop()
              if vim.uv.now() > deadline then
                pending = false
                return
              end
              timer:start(
                150,
                0,
                vim.schedule_wrap(function()
                  if pending and menu.win and not menu.win:is_open() then
                    pcall(menu.open_loading, ctx)
                  end
                end)
              )
            end

            trigger.show_emitter:on(function(event)
              -- blink already handles the manual case with its own 500ms timer
              if event.context.trigger.kind == "manual" then
                return
              end
              pending = true
              deadline = vim.uv.now() + 5000
              arm(event.context)
            end)

            -- Real items arrived: we are done, stop competing with the menu.
            list.show_emitter:on(function()
              pending = false
              timer:stop()
            end)

            -- blink hides the menu as soon as the instant sources come back
            -- empty, which for a trigger character is immediately. Without
            -- this the loading menu opens, gets torn down, and reopens when
            -- the LSP answers -- a flicker that is worse than the gap it was
            -- meant to fill. If the request is still outstanding, put it back.
            list.hide_emitter:on(function()
              if pending and menu.context then
                arm(menu.context)
              else
                timer:stop()
              end
            end)

            vim.api.nvim_create_autocmd("InsertLeave", {
              group = "blink_loading_hint",
              callback = function()
                pending = false
                timer:stop()
              end,
            })
          end)
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            -- The "random names" problem: typing `tea` was offering
            -- `teardownTraceSubscriber` and `Teachers` -- symbols that live in
            -- some package under node_modules, not in the file being edited.
            -- Those are auto-import candidates: tsserver offers every exported
            -- symbol in the project as something it could import for you.
            --
            -- vtsls maps this setting straight onto tsserver's
            -- includeCompletionsForModuleExports (see suggest.autoImports in
            -- @vtsls/language-service), so turning it off restricts
            -- completions to what is actually in scope: locals, parameters,
            -- members, and things already imported in this file.
            --
            -- The cost is real and worth stating: typing `useState` in a file
            -- that has not imported it will no longer offer to add the import.
            -- Import it once by hand and it completes normally thereafter.
            typescript = { suggest = { autoImports = false } },
            javascript = { suggest = { autoImports = false } },
            vtsls = {
              experimental = {
                completion = {
                  -- vtsls was returning 1074 items per keystroke for blink to
                  -- draw 50 of. Everything past the cap was serialized over
                  -- the wire and scored for nothing.
                  entriesLimit = 100,
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
          },
        },
      },
    },
  },
}
