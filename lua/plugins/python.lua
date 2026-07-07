-- Pyright flags `torch.arange` etc. with reportPrivateImportUsage because
-- pytorch exports most functions dynamically (from torch._C._VariableFunctions
-- import *), which Pyright can't see as public API. Known upstream issue;
-- the standard workaround is to disable that one diagnostic.
local overrides = {
  diagnosticSeverityOverrides = {
    reportPrivateImportUsage = "none",
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = { analysis = overrides },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = { analysis = overrides },
          },
        },
      },
    },
  },
}
