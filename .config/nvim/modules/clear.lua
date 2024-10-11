local module = {
  name = 'clear',
  desc = 'defines a clear session command for buffers, prompt, etc',
  plugins = {},
  fn = function ()
    UseKeymap('clear', function ()
      local is_nofile = vim.bo.buftype == 'nofile'

      -- close lsp info window
      if vim.bo.filetype == 'markdown' and is_nofile then
        vim.api.nvim_win_close(0, true)
      end

      -- close harpoon window
      if vim.bo.filetype == 'harpoon' then
        vim.api.nvim_win_close(0, true)
      end

      -- close lsp diagnostics window
      local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
      local is_diagnostics = first_line and first_line:find('Diagnostics:')
      if is_nofile and first_line and is_diagnostics then
        vim.api.nvim_win_close(0, true)
      end

      -- unload buffers without files
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if vim.api.nvim_buf_get_option(buf, 'modified') then
            goto continue
          end
          if buf_name ~= '' and vim.fn.filereadable(buf_name) == 0 then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
          ::continue::
        end
      end

      -- clear search highlights
      vim.cmd('nohlsearch')

      -- clear prompt
      vim.cmd('echo ""')

      -- close mini.files window
      if vim.bo.filetype == 'minifiles' then
        require('mini.files').close()
      end

      -- close lsp info window
      vim.api.nvim_feedkeys('jk', 'n', false)
    end)
  end
}

return module

