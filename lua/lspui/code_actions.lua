local lsp = vim.lsp
local api = vim.api
local win = require('lspui.utils.window')

local M = {}

M.action_picker = function()
  local params = lsp.util.make_range_params()
  params.context = {
    diagnostics = lsp.diagnostic.get_line_diagnostics()
  }
  local results_lsp, err = lsp.buf_request_sync(0, "textDocument/codeAction", params, 10000)

  if err then
    print("ERROR: " .. err)
    return
  end

  if not results_lsp or vim.tbl_isempty(results_lsp) then
    print("No results from textDocument/codeAction")
    return
  end

  local _, response = next(results_lsp)
  if not response then
    print("No code actions available")
    return
  end

  local results = response.result
  if not results or #results == 0 then
    print("No code actions available")
    return
  end

  local lines = {}
  for i,x in ipairs(results) do
    lines[i] = i .. ': ' .. x.title
  end

  win.create_win({
    text = lines,
    set_buf_settings = function(bufh, win_id)
      api.nvim_buf_set_keymap(bufh, "n", "h", "<nop>", {})
      api.nvim_buf_set_keymap(bufh, "n", "l", "<nop>", {})
      win.disable_insert(bufh)
      api.nvim_buf_set_keymap(bufh, "n", "<esc>", "<cmd>q<CR>", {})

      api.nvim_buf_set_keymap(bufh, "n", "<CR>",
        "<cmd>lua require('lspui.code_actions').select_current_action()<CR>", {})

      api.nvim_win_set_option(win_id, 'winhl', 'Normal:Normal')
    end,
    height = #lines
  })
end

M.select_current_action = function()
  local line = vim.api.nvim_get_current_line()
  print(line)
  api.nvim_buf_delete(0, { force = true })
end

return M
