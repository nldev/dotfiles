local module = {
  name = 'cancel',
  desc = 'defines a universal clear and cancel keymap.',
  plugins = {},
  fn = function ()
    UseKeymap('clear', function ()
      local is_nofile = vim.bo.buftype == 'nofile'
      local is_floating = vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).relative ~= ''

      -- clear search highlights
      vim.cmd'nohlsearch'

      -- clear prompt
      vim.cmd'echo ""'

      -- workspaces
      if vim.bo.filetype == 'workspaces' then
        vim.cmd'bd!'
        return
      end

      -- terminal
      if vim.bo.buftype == 'terminal' then
        vim.fn.chansend(vim.b.terminal_job_id, '\x0c')
        vim.fn.chansend(vim.b.terminal_job_id, '\x1b')
        vim.cmd'norm G0'
        return
      end

      -- close lsp info window
      if vim.bo.filetype == 'markdown' and is_nofile then
        vim.api.nvim_win_close(0, true)
        return
      end

      -- close telescope window
      if vim.bo.filetype == 'TelescopePrompt' then
        vim.cmd'bd!'
        return
      end

      -- close harpoon window
      if vim.bo.filetype == 'harpoon' then
        vim.api.nvim_win_close(0, true)
        return
      end

      -- close quickfix window
      if vim.bo.buftype == 'quickfix' then
        vim.cmd'wincmd c'
        return
      end

      -- close help window
      if vim.bo.buftype == 'help' then
        vim.cmd'wincmd c'
        return
      end

      -- close netrw buffer
      if vim.bo.filetype == 'netrw' then
        vim.cmd'bd'
        return
      end

      -- close undotree
      if vim.bo.filetype == 'undotree' then
        vim.api.nvim_win_close(0, true)
        return
      end

      -- close org-roam-select window
      local a = vim.api.nvim_buf_get_name(0)
      local is_org_roam_select = a:find'org%-roam%-select'
      if is_org_roam_select then
        vim.cmd'bd!'
        return
      end

      -- close lsp diagnostics window
      local b = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
      local is_diagnostics = b and b:find'Diagnostics:'
      if is_nofile and b and is_diagnostics then
        vim.api.nvim_win_close(0, true)
        return
      end

      -- close mini.files window
      if vim.bo.filetype == 'minifiles' then
        -- require'mini.files'.synchronize()
        -- require'mini.files'.close()
        vim.api.nvim_win_close(0, true)
        return
      end

      -- close peek definition window
      if vim.bo.buftype == 'nofile' and is_floating then
        vim.api.nvim_win_close(0, true)
        return
      end

      -- close lsp info window
      vim.api.nvim_feedkeys('lh', 'n', false)
    end)
  end
}

return module

