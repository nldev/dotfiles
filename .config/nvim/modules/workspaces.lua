local module = {
  name = 'workspaces',
  desc = 'workspace management and selection',
  plugins = {},
  fn = function ()
    vim.cmd'au BufRead,BufNewFile *.workspaces set filetype=workspaces'

    -- Utils
    -- API
    _G.__workspaces__ = {}

    function _G.__workspaces__.delete_whitespace ()
      local bufnr = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      for i = #lines, 1, -1 do
        if lines[i]:match'^%s*$' then
          vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, {})
        end
      end
      vim.cmd[[%s/\s\+$//e]]
      vim.cmd'nohlsearch'
      vim.cmd'echo ""'
    end


    function __workspaces__.open_workspaces_buffer()
      if vim.bo.filetype == 'workspaces' then
        _G.__workspaces__.delete_whitespace()
        vim.cmd'silent! w'
        vim.cmd'bdelete!'
        return
      end
      local file = io.open('/home/user/.local/share/nvim/me.workspaces', 'r')
      local line_count = 0
      if file then
        for _ in file:lines() do
          line_count = line_count + 1
        end
        file:close()
      end
      local width = math.ceil(vim.o.columns * 0.67)
      local height = math.max(5, line_count + 2)
      local opts = {
        title = 'Workspaces',
        style = 'minimal',
        relative = 'editor',
        width = width,
        height = height,
        col = math.ceil((vim.o.columns - width) / 2) - 4,
        row = math.ceil((vim.o.lines - height) / 2),
        border = 'rounded',
      }
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_win(buf, true, opts)
      vim.cmd'edit ~/.local/share/nvim/me.workspaces'
      vim.cmd'norm! gg'
    end

    function __workspaces__.cd_to_directory ()
      local line_num = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
      local label, dir = line:match'^(.-):%s*(.+)$'
      dir = dir:gsub('%s+$', '')
      if dir then
        _G.__workspaces__.delete_whitespace()
        vim.cmd'silent! w'
        vim.fn.chdir(dir)
        vim.cmd('cd ' .. dir)
        vim.cmd'bdelete!'
        print('Changed workspace to ' .. label)
        vim.defer_fn(function () vim.cmd'echo ""' end, 2000)
      else
        print('Error: Directory ' .. dir .. ' does not exist')
      end
    end

    function _G.__workspaces__.set_workspace ()
      local count = vim.v.count
      if count == 0 then
        _G.__workspaces__.cd_to_directory()
        return
      end
      local max_line = vim.api.nvim_buf_line_count(0)
      local line = math.min(count, max_line)
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      _G.__workspaces__.cd_to_directory()
    end

    local conceal_namespace = vim.api.nvim_create_namespace'workspaces_conceal'
    local virtual_namespace = vim.api.nvim_create_namespace'workspaces_virtual'
    function _G.__workspaces__.render_virtual_text(bufnr)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      vim.api.nvim_buf_clear_namespace(bufnr, conceal_namespace, 0, -1)
      vim.api.nvim_buf_clear_namespace(bufnr, virtual_namespace, 0, -1)
      for linenr, line in ipairs(lines) do
        local label, dir = line:match'^(.-):%s*(.+)$'
        if label and dir then
          vim.api.nvim_buf_set_extmark(bufnr, conceal_namespace, linenr - 1, 0, {
            end_col = #line,
            conceal = ' ',
          })
          vim.api.nvim_buf_set_extmark(bufnr, virtual_namespace, linenr - 1, 0, {
            virt_text = { { label, 'Keyword' } },
            virt_text_pos = 'overlay',
          })
        end
      end
    end

    -- Autocommand
    vim.api.nvim_create_augroup('Workspaces', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = 'Workspaces',
      pattern = 'workspaces',
      callback = function (args)
        vim.api.nvim_buf_set_keymap(0, 'n', '<cr>', ':<c-u>lua _G.__workspaces__.set_workspace()<cr>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<esc>', ':bdelete!<cr>', { noremap = true, silent = true })
        -- FIXME: use on save autocmd instead
        vim.api.nvim_buf_set_keymap(0, 'n', '<c-s>', [[
        :lua _G.__workspaces__.delete_whitespace()<cr>
        :silent w!<cr>:bdelete!<cr>
        ]], { noremap = true, silent = true })
        local bufnr = args.buf
        _G.__workspaces__.render_virtual_text(bufnr)
        vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
          buffer = bufnr,
          callback = function () _G.__workspaces__.render_virtual_text(bufnr) end,
        })
      end,
    })

    -- Keymaps
    UseKeymap('workspaces_select', function ()
      _G.__workspaces__.open_workspaces_buffer()
    end)
  end,
}


return module
