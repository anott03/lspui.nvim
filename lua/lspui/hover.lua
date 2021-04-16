local lsp = vim.lsp
local util = vim.lsp.util
local api = vim.api
local win = require('lspui.utils.window')
local M = {}

M.hover_doc = function()
  local params = util.make_position_params()
  lsp.buf_request(0,'textDocument/hover', params, function(_, method, result)
    if not (result and result.contents) then
      return
    end

    local markdown_lines = lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = lsp.util.trim_empty_lines(markdown_lines)

    if vim.tbl_isempty(markdown_lines) then
      return
    end

    win.create_win({
      text = markdown_lines,
      height = #markdown_lines,
      set_buf_settings = function(_, win_id)
        api.nvim_win_set_option(win_id, 'winhl', 'Normal:LspuiNormal')
      end
    })
  end)
end

return M
