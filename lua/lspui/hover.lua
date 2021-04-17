local lsp = vim.lsp
local util = vim.lsp.util
local api = vim.api
local win = require('lspui.utils.window')
local M = {}

local hover_doc_win_id

M.hover_doc = function()
  local params = util.make_position_params()
  local current_win = api.nvim_get_current_win()
  lsp.buf_request(0,'textDocument/hover', params, function(_, _, result)
    if not (result and result.contents) then
      return
    end

    local markdown_lines = lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = lsp.util.trim_empty_lines(markdown_lines)

    if vim.tbl_isempty(markdown_lines) then
      return
    end

    local ft
    local _width = 40
    for i, k in pairs(markdown_lines) do
      if k:sub(1,3) == '```' then
        if #k > 3 then
          ft = k:sub(4, -1)
        end
        table.remove(markdown_lines, i)
      end
    end

    for _, k in pairs(markdown_lines) do
      if #k > _width then _width = #k end
    end

    hover_doc_win_id, _ = win.create_win({
      text = markdown_lines,
      height = #markdown_lines,
      width = _width,
      focusable = false,
      set_buf_settings = function(bufh, win_id)
        api.nvim_win_set_option(win_id, 'winhl', 'Normal:LspuiNormal')
        api.nvim_buf_set_keymap(bufh, "n", "<esc>", "<cmd>q!<cr>", {})
        api.nvim_buf_set_option(bufh, "modifiable", false)
        api.nvim_buf_set_option(bufh, "filetype", ft)
      end
    })

    api.nvim_set_current_win(current_win)
  end)
end

M.close_hover_doc = function()
  api.nvim_win_close(hover_doc_win_id, true)
end

return M
