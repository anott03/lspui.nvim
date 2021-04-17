local lsp = vim.lsp
local util = vim.lsp.util
local api = vim.api
local win = require('lspui.utils.window')
local M = {}

local function close_hover_win(win_id)
  lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden","BufLeave", "InsertCharPre"}, win_id)
end

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

    local hover_doc_win_id, _ = win.create_win({
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
    close_hover_win(hover_doc_win_id)
  end)
end

M.line_diagnostics = function()
  local lines = {
    "Diagnostics:"
  }

  local current_win = api.nvim_get_current_win()
  local line_diagnostics = lsp.diagnostic.get_line_diagnostics()

  local _width = 40
  for i, k in pairs(line_diagnostics) do
    if #k.message > _width then _width = #k.message end
    table.insert(lines, i .. '. ' .. k.message)
  end

  local diagnostics_win_id = win.create_win({
    width = _width,
    height = #lines,
    text = lines,

    set_buf_settings = function(bufh, win_id)
      api.nvim_win_set_option(win_id, 'winhl', 'Normal:LspuiNormal')
      api.nvim_buf_add_highlight(bufh, -1, "LspuiTitle", 0, 0, -1)
    end
  })

  api.nvim_set_current_win(current_win)
  close_hover_win(diagnostics_win_id)
end

return M
