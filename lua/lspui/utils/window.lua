local Border = require('plenary.window.border')
local api = vim.api

local M = {}

local default_win_opts = {
  relative = "cursor",
  row = 1,
  col = 0,
  width = 40,
  height = 2,
  style = "minimal",
  focusable = true,
  border = {
    {"╭", "LspuiBorder"},
    {"─", "LspuiBorder"},
    {"╮", "LspuiBorder"},
    {"│", "LspuiBorder"},
    {"╯", "LspuiBorder"},
    {"─", "LspuiBorder"},
    {"╰", "LspuiBorder"},
    {"│", "LspuiBorder"}
  },
}

M.create_win = function(opts)
  local win_opts = vim.tbl_deep_extend("keep", opts, default_win_opts)
  win_opts.set_content = nil
  win_opts.set_buf_settings = nil
  win_opts.text = nil

  local bufh = opts.bufh or api.nvim_create_buf(false, true)
  local win = api.nvim_open_win(bufh, true, win_opts)
  vim.api.nvim_win_set_buf(win, bufh)

  vim.api.nvim_win_set_option(win, 'winblend', opts.winblend or 1)

  if opts.text then
    api.nvim_buf_set_lines(bufh, 0, #opts.text, false, opts.text)
  end

  if opts.set_content then
    opts.set_content(bufh, win)
  end

  if opts.set_buf_settings then
    opts.set_buf_settings(bufh, win)
  end

  return win, bufh
end

return M
