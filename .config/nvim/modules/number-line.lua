local module = {
  name = 'number-line',
  desc = 'configuration for number line',
  plugins = {},
  fn = function ()
    -- Ensure number line is on by default.
    vim.o.number = true

    -- Ensure relative number line is off by default.
    vim.o.relativenumber = false

    -- Ensure signcolumn is on by default.
    vim.o.signcolumn = 'yes'

    -- Apply settings to all existing windows.
    local function apply_settings ()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        vim.api.nvim_win_set_option(win, 'number', vim.o.number)
        vim.api.nvim_win_set_option(win, 'relativenumber', vim.o.relativenumber)
        vim.api.nvim_win_set_option(win, 'signcolumn', vim.o.signcolumn)
      end
    end
    apply_settings()

    -- Ensure all new windows and buffers inherit these settings.
    vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'VimResized' }, {
      callback = function ()
        vim.wo.number = vim.o.number
        vim.wo.relativenumber = vim.o.relativenumber
        vim.wo.signcolumn = vim.o.signcolumn
      end
    })

    -- Keymaps
    UseKeymap('vim_signcolumn', function ()
      if vim.o.signcolumn == 'yes' then
        vim.o.signcolumn = 'no'
        apply_settings()
        print'signcolumn OFF'
      else
        vim.o.signcolumn = 'yes'
        apply_settings()
        print'signcolumn ON'
      end
    end)

    UseKeymap('vim_number_line', function ()
      if vim.wo.number then
        vim.wo.number = false
        apply_settings()
        print'number line OFF'
      else
        vim.wo.number = true
        apply_settings()
        print'number line ON'
      end
    end)

    UseKeymap('vim_relative_number_line', function ()
      if vim.wo.relativenumber then
        vim.wo.relativenumber = false
        apply_settings()
        print'relative number line OFF'
      else
        vim.wo.relativenumber = true
        apply_settings()
        print'relative number line ON'
      end
    end)
  end,
}

return module

