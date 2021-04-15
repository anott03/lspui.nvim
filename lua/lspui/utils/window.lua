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
end

return M
