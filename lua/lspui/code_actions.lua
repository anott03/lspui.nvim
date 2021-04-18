local lsp = vim.lsp
local api = vim.api
local win = require('lspui.utils.window')

local M = {}

local function perform_action(val)
  if val.edit or type(val.command) == "table" then
    if val.edit then
      vim.lsp.util.apply_workspace_edit(val.edit)
    end
    if type(val.command) == "table" then
      vim.lsp.buf.execute_command(val.command)
    end
  else
    vim.lsp.buf.execute_command(val)
  end
end

local function create_select_current_action(results)
  M.select_current_action = function()
    local line = vim.api.nvim_get_current_line()
    -- print(line)
    local index = tonumber(line:sub(2, 2))
    api.nvim_buf_delete(0, { force = true })
    local val = results[index]
    pcall(perform_action, val)
  end
end

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

  local _width
  local lines = {}
  for i,x in ipairs(results) do
    lines[i] = '[' .. i .. '] ' .. x.title

    if not _width then
      _width = #lines[i]
    end
    if #lines[i] > _width then
      _width = #lines[i]
    end
  end

  create_select_current_action(results)

  table.insert(lines, 1, "Code Actions:")

  win.create_win({
    text = lines,
    set_buf_settings = function(bufh, win_id)
      api.nvim_buf_set_option(bufh, "modifiable", false)
      api.nvim_buf_set_keymap(bufh, "n", "<esc>", "<cmd>q<CR>", {})

      api.nvim_buf_set_keymap(bufh, "n", "<CR>",
        "<cmd>lua require('lspui.code_actions').select_current_action()<CR>", {})
      api.nvim_feedkeys("l", "n", {})

      api.nvim_win_set_option(win_id, 'winhl', 'Normal:LspuiNormal')
      api.nvim_buf_add_highlight(bufh, -1, "LspuiTitle", 0, 0, -1)
      vim.cmd([[set wrap]])
    end,
    height = #lines,
    width = _width
  })
end

return M
