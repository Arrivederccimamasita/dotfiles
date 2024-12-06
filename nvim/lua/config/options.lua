-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Set Default shell in terminal mode
vim.opt.foldmethod = "manual"
vim.opt.shiftwidth = 4 -- Size of an indent

-- Search with wildcards
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Let 8 lines until scroll
vim.opt.scrolloff = 8

vim.opt.updatetime = 50

-- Set GIT_EDITOR to use nvr if Neovim and nvr are available
if vim.fn.has("nvim") == 1 and vim.fn.executable("nvr") == 1 then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end
