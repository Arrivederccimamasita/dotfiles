return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      -- your terminal configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      win = {
        wo = {
          relativenumber = true,
        },
        keys = {
          q = "",
          term_normal = {
            "<leader>",
            function(self)
              self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
              if self.esc_timer:is_active() then
                self.esc_timer:stop()
                vim.cmd("stopinsert")
              else
                self.esc_timer:start(200, 0, function() end)
                return "<leader>"
              end
            end,
            mode = "t",
            expr = true,
            desc = "Double leader to normal mode",
          },
        },
      },
    },
  },
}
