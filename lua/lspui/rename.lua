local api = vim.api
local fn = vim.fn
local lsp = vim.lsp
local util = vim.lsp.util
local win = require('lspui.utils.window')

local M = {}

M.rename_token = function()
  -- create window
  win.create_win({
    height = 1,

    set_content = function(bufh)
      api.nvim_buf_set_option(bufh,'buftype','prompt')
      fn.prompt_setprompt(bufh, "Rename to > ")
      vim.cmd [[startinsert!]]

      fn.prompt_setcallback(bufh, function(new_name)
        local params = util.make_position_params()
        params.newName = new_name
        lsp.buf_request(0,'textDocument/rename', params)
        api.nvim_buf_delete(bufh, { force = true })
      end)
    end,

    set_buf_settings = function(bufh, win_id)
      api.nvim_win_set_option(win_id, 'winhl', 'Normal:LspuiNormal')
      api.nvim_buf_set_keymap(bufh, "i", "<esc>", "<cmd>q!<CR>", {})
      api.nvim_buf_set_keymap(bufh, "i", "<CR>",
          "<cmd>lua require('lspui.rename').rename_the_token(" ..bufh.. ")<CR>", {})
    end
  })
end

M.rename_the_token = function(bufh)
  local new_name = vim.trim(api.nvim_get_current_line():sub(#"Rename to >"+1, -1))
  print(new_name)

  local params = util.make_position_params()
  params.newName = new_name
  lsp.buf_request(0,'textDocument/rename', params)
  api.nvim_buf_delete(bufh, { force = true })

  vim.cmd [[stopinsert!]]
end

return M
