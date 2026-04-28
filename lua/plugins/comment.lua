return {
  {
    'folke/ts-comments.nvim',
    enabled = false,
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
    config = function(_, opts)
      require('Comment').setup(opts)

      vim.keymap.set('x', 'gcc', '<Plug>(comment_toggle_linewise_visual)', {
        silent = true,
        desc = 'Toggle comment (visual)',
      })
    end,
  },
}
