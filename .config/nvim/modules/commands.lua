local module = {
  name = 'commands',
  desc = 'useful command line utilities',
  plugins = {},
  fn = function ()
    -- :KillAllBuffers
    vim.api.nvim_create_user_command('KillAllBuffers', function ()
      vim.cmd'bufdo! bwipeout!'
    end, { nargs = 0 })

    -- :WhereAmI
    vim.api.nvim_create_user_command('WhereAmI', function ()
      vim.cmd("echo expand('%:p')")
    end, { nargs = 0 })

    -- :Delete
    vim.api.nvim_create_user_command('Delete', function ()
      vim.cmd'exec \'silent !rm %\' | bdelete!'
    end, { nargs = 0 })

    -- :Rename
    vim.api.nvim_create_user_command('Rename', function (args)
      local current_file = vim.fn.expand'%:p'
      local current_dir = vim.fn.fnamemodify(current_file, ':h')
      local new_name = args.args
      local new_path
      if vim.fn.isdirectory(new_name) == 1 or new_name:sub(1, 1) == '/' then
        new_path = new_name
      else
        new_path = current_dir .. '/' .. new_name
      end
      local escaped_new_path = vim.fn.fnameescape(new_path)
      vim.cmd('saveas ' .. escaped_new_path)
      vim.cmd('silent !rm ' .. vim.fn.fnameescape(current_file))
      vim.cmd('bdelete! ' .. vim.fn.bufnr(current_file))
      vim.cmd('edit ' .. escaped_new_path)
    end, {
      nargs = 1,
      complete = 'file',
    })
  end,
}

return module

