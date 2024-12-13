--false Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

-- Terminal
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<leader>ft")

vim.keymap.set("n", "<leader>t", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

-- Undo Tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Windowns Move and Tmux integration
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<leader>_", "<C-W>s", { desc = "Split Window Below", remap = true })

vim.keymap.set("n", "C-h", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
vim.keymap.set("n", "C-j", "<Cmd>NvimTmuxNavigateDown<CR>", {})
vim.keymap.set("n", "C-k", "<Cmd>NvimTmuxNavigateUp<CR>", {})
vim.keymap.set("n", "C-l", "<Cmd>NvimTmuxNavigateRight<CR>", {})

-- Obsidina Quick Note
vim.keymap.set("n", "<leader>ont", "<Cmd>ObsidianNewFromTemplate<CR>", {})
vim.keymap.set("n", "<leader>ond", "<Cmd>ObsidianDailies<CR>", {})
vim.keymap.set("n", "<leader>onn", "<Cmd>ObsidianNew<CR>", {})
vim.keymap.set("n", "<leader>os", "<Cmd>ObsidianSearch<CR>", {})

-- Function to check clipboard with retries
local function getRelativeFilepath(retries, delay)
  local relative_filepath
  for i = 1, retries do
    relative_filepath = vim.fn.getreg("+")
    if relative_filepath ~= "" then
      return relative_filepath -- Return filepath if clipboard is not empty
    end
    vim.loop.sleep(delay) -- Wait before retrying
  end
  return nil -- Return nil if clipboard is still empty after retries
end

-- Function to handle editing from Lazygit
function LazygitEdit(original_buffer)
  local current_bufnr = vim.fn.bufnr("%")
  local channel_id = vim.fn.getbufvar(current_bufnr, "terminal_job_id")

  if not channel_id then
    vim.notify("No terminal job ID found.", vim.log.levels.ERROR)
    return
  end

  vim.fn.chansend(channel_id, "\15") -- \15 is <c-o>
  vim.cmd("close") -- Close Lazygit

  local relative_filepath = getRelativeFilepath(5, 50)
  if not relative_filepath then
    vim.notify("Clipboard is empty or invalid.", vim.log.levels.ERROR)
    return
  end

  local winid = vim.fn.bufwinid(original_buffer)

  if winid == -1 then
    vim.notify("Could not find the original window.", vim.log.levels.ERROR)
    return
  end

  vim.fn.win_gotoid(winid)
  vim.cmd("e " .. relative_filepath)
end

-- Function to start Lazygit in a floating terminal
function StartLazygit()
  local current_buffer = vim.api.nvim_get_current_buf()
  local float_term = Util.terminal.open({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })

  vim.api.nvim_buf_set_keymap(
    float_term.buf,
    "t",
    "<c-e>",
    string.format([[<Cmd>lua LazygitEdit(%d)<CR>]], current_buffer),
    { noremap = true, silent = true }
  )
end

vim.api.nvim_set_keymap("n", "<leader>gg", [[<Cmd>lua StartLazygit()<CR>]], { noremap = true, silent = true })
