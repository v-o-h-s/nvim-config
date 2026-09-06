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
-- highlight is wanted. Only the vtsls entry cap survives here.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
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
