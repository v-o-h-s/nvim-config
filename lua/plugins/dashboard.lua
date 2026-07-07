local header = require("config.ascii")

return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = header,
        },
      },
    },
  },
}
