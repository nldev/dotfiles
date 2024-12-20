local module = {
  name = 'toasts',
  desc = 'toast windows',
  dependencies = {},
  plugins = {},
  fn = function ()
    vim.cmd'command! -nargs=1 Toast lua Toast(<q-args>)'
    function _G.Toast (msg, time)
      if not time then
        time = 2000
      end
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { ' ' .. msg })
      local ui = vim.api.nvim_list_uis()[1]
      local width = ui.width
      local win_width = #msg + 2
      local win_height = 1
      local col = width - win_width - 5
      local row = 1
      local win = vim.api.nvim_open_win(buf, false, {
        relative = 'editor',
        width = win_width,
        height = win_height,
        col = col,
        row = row,
        focusable = false,
        style = 'minimal',
        border = 'rounded',
      })
      vim.defer_fn(function ()
        vim.api.nvim_win_close(win, true)
      end, time)
    end
end
}

return module

