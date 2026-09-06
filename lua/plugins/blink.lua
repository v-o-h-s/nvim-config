-- Completion tuning for a CPU that is stuck at 400MHz (dead-battery EC clamp),
-- where every per-keystroke cost is ~12x what it should be. Measured on this
-- machine: an idle completion request to vtsls is 8-85ms, but the same request
-- while other LSP traffic is in flight is 336ms+. So the goal here is to do as
-- little work as possible per keystroke and to avoid extra LSP round-trips.
return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        providers = {
          lsp = {
            -- The real fix for "the menu takes seconds to appear". blink treats
            -- a provider as blocking by default: the menu is not drawn until
            -- the provider returns or its timeout expires. With `async = false`
            -- and a 2000ms timeout, every keystroke waited on vtsls, which
            -- answers in ~40ms when idle but degrades past 2s once a request is
            -- in flight per keystroke. Measured here: median 2134ms to first
            -- paint, sitting exactly on the timeout.
            --
            -- Marking it async draws the menu immediately from the instant
            -- sources (buffer/snippets/path) and folds the LSP items in when
            -- they land, instead of showing nothing until they do.
            async = true,
            -- If vtsls has not answered within this, it is not going to feel
            -- interactive anyway; let the keystroke go and pick it up on the
            -- next one rather than pinning a stale request open for 2s.
            timeout_ms = 500,
          },
        },
      },
      completion = {
        list = {
          -- 200 items all get scored and drawn on every keystroke. The menu
          -- shows a handful; the rest is wasted work.
          max_items = 50,
        },
        menu = {
          draw = {
            -- LazyVim highlights each menu item by running treesitter over it.
            -- That is a parse per item per keystroke; the fallback highlighting
            -- looks nearly identical for a fraction of the cost.
            treesitter = {},
          },
        },
        documentation = {
          -- Each doc popup is an extra resolve round-trip to the LSP. Waiting a
          -- bit longer means scrolling the menu no longer fires a request per
          -- item you pass over.
          auto_show_delay_ms = 500,
        },
        accept = {
          auto_brackets = {
            -- Keeps bracket insertion, but drops the semantic-token request
            -- (400ms timeout) that blocks on every accept.
            semantic_token_resolution = { enabled = false },
          },
        },
      },
    },
  },
}
