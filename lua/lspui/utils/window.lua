local Border = require('plenary.window.border')
local api = vim.api

local M = {}

M.create_win = function(opts)
  local bufh = opts.bufh or api.nvim_create_buf(false, true)
  local win_opts = opts.win_opts or {
    relative = opts.relative or "cursor",
    row = opts.row or 1,
    col = opts.row or 0,
    width = opts.width or 40,
    height = opts.height or 2,
    style = opts.style or "minimal",
    border = opts.style or "double"
  }
  local win = api.nvim_open_win(bufh, true, win_opts)
  vim.api.nvim_win_set_buf(win, bufh)
  -- local border = Border:new(bufh, win, win_opts, {})

  vim.api.nvim_win_set_option(win, 'winblend', opts.winblend or 1)
  if opts.text then
    api.nvim_buf_set_lines(bufh, 0, #opts.text, false, opts.text)
  end

  if opts.set_buf_settings then
    opts.set_buf_settings(bufh)
  end
end

M.disable_insert = function(bufh)
  -- there must be a better way to do this
  api.nvim_buf_set_keymap(bufh, "n", "i", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "I", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "v", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "V", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "o", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "O", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "a", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "A", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "d", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "D", "<nop>", {})
  api.nvim_buf_set_keymap(bufh, "n", "Q", "<nop>", {})
  api.nvim_buf_set_option(bufh, "readonly", true)
end

return M
