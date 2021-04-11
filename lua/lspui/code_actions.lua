local lsp = vim.lsp
local api = vim.api
local win = require('lspui.utils.window')

local M = {}

M.action_picker = function()
  -- local window_stats = float.percentage_range_window(0.5, 0.5)
  local params = lsp.util.make_range_params()
  params.context = {
    diagnostics = lsp.diagnostic.get_line_diagnostics()
  }
  local results_lsp, err = lsp.buf_request_sync(0, "textDocument/codeAction", params, 10000)
  -- print(vim.inspect(results_lsp[next(results_lsp)]))

  win.create_win({
    text = {"   some text"},
    set_buf_settings = function(bufh, set_hl)
      api.nvim_buf_set_keymap(bufh, "n", "h", "<nop>", {})
      api.nvim_buf_set_keymap(bufh, "n", "l", "<nop>", {})
      win.disable_insert(bufh)
      api.nvim_buf_set_keymap(bufh, "n", "<esc>", "<cmd>q<CR>", {})
    end
  })
end

return M
