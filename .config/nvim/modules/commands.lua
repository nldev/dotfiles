local module = {
  name = 'commands',
  desc = 'useful command line utilities',
  plugins = {},
  fn = function ()
    -- :Reorder
    vim.api.nvim_create_user_command('Reorder', function(opts)
      local start_line = opts.line1
      local end_line = opts.line2
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      local parsed = {}
      for _, line in ipairs(lines) do
        local number = tonumber(line:match("=%s*(%d+)"))
        if number then
          table.insert(parsed, { line_content = line, number = number })
        end
      end
      table.sort(parsed, function(a, b) return a.number < b.number end)
      local reordered_lines = {}
      for _, entry in ipairs(parsed) do
        table.insert(reordered_lines, entry.line_content)
      end
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, reordered_lines)
      print(#lines .. ' lines reordered.')
    end, { nargs = 0, range = true })

    -- :KillAllBuffers
    vim.api.nvim_create_user_command('KillAllBuffers', function ()
      vim.cmd('bufdo! bwipeout!')
    end, { nargs = 0 })

    -- :WhereAmI
    vim.api.nvim_create_user_command('WhereAmI', function ()
      vim.cmd("echo expand('%:p')")
    end, { nargs = 0 })

    -- :Delete
    vim.api.nvim_create_user_command('Delete', function ()
      vim.cmd("exec 'silent !rm %' | bdelete!")
    end, { nargs = 0 })

    -- :Rename
    vim.api.nvim_create_user_command('Rename', function (args)
      local current_file = vim.fn.expand('%:p')
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

