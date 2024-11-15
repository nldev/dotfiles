local module = {
  name = 'clear',
  desc = 'defines a universael clear / cancel keymap.',
  plugins = {},
  fn = function ()
    UseKeymap('reload_file', function () vim.cmd'e' end)
    UseKeymap('clear', function ()
      local is_nofile = vim.bo.buftype == 'nofile'

      -- terminal
      if vim.bo.buftype == 'terminal' then
        vim.fn.chansend(vim.b.terminal_job_id, '\x0c')
      end

      -- close lsp info window
      if vim.bo.filetype == 'markdown' and is_nofile then
        vim.api.nvim_win_close(0, true)
      end

      -- close telescope window
      if vim.bo.filetype == 'TelescopePrompt' then
        vim.cmd'bd!'
      end

      -- close harpoon window
      if vim.bo.filetype == 'harpoon' then
        vim.api.nvim_win_close(0, true)
      end

      -- close quickfix window
      if vim.bo.buftype == 'quickfix' then
        vim.cmd'wincmd c'
      end

      -- close help window
      if vim.bo.buftype == 'help' then
        vim.cmd'wincmd c'
      end

      -- close netrw buffer
      if vim.bo.filetype == 'netrw' then
        vim.cmd'bd'
      end

      -- close undotree
      if vim.bo.filetype == 'undotree' then
        vim.api.nvim_win_close(0, true)
      end

      -- close org-roam-select window
      local a = vim.api.nvim_buf_get_name(0)
      local is_org_roam_select = a:find'org%-roam%-select'
      if is_org_roam_select then
        vim.cmd'bd!'
      end

      -- close lsp diagnostics window
      local b = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
      local is_diagnostics = b and b:find'Diagnostics:'
      if is_nofile and b and is_diagnostics then
        vim.api.nvim_win_close(0, true)
      end

      -- clear search highlights
      vim.cmd'nohlsearch'

      -- clear prompt
      vim.cmd'echo ""'

      -- close mini.files window
      if vim.bo.filetype == 'minifiles' then
        require'mini.files'.synchronize()
        require'mini.files'.close()
      end

      -- close lsp info window
      vim.api.nvim_feedkeys('lh', 'n', false)
    end)
  end
}

return module

