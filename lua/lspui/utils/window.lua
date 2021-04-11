local Border = require('plenary.window.border')
local api = vim.api

local set_hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui

  vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

local M = {}

M.create_win = function(opts)
  local bufh = opts.bufh or api.nvim_create_buf(false, true)
  local win_opts = opts.win_opts or {
    relative = "cursor",
    row = 1,
    col = 0,
    width = 40,
    height = 2,
    style = "minimal",
    border = "double"
  }
  local win = api.nvim_open_win(bufh, true, win_opts)
  vim.api.nvim_win_set_buf(win, bufh)
  -- local border = Border:new(bufh, win, win_opts, {})

  vim.api.nvim_win_set_option(win, 'winblend', opts.winblend or 1)
  if opts.text then
    api.nvim_buf_set_lines(bufh, 0, #opts.text, false, opts.text)
  end

  if opts.set_buf_settings then
    opts.set_buf_settings(bufh, set_hl)
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
