return {
  "folke/noice.nvim",
  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = "lsp",
        kind = "message",
        any = {
          { find = "(bitbake)" },
          { find = "Add" },
        },
      },
      opts = { skip = "true" },
    })
  end,
}
