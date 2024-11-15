local module = {
  name = 'vim',
  desc = 'general settings',
  plugins = {
    -- 'airblade/vim-rooter',
    'karb94/neoscroll.nvim',
  },
  fn = function ()
    -- use utf-8 encoding
    vim.cmd'set encoding=utf-8'

    -- use unix style line endings
    vim.cmd'set fileformat=unix'

    -- do not wrap text
    vim.wo.wrap = false

    -- do not line break
    vim.wo.linebreak = false

    -- set highlight on search
    vim.o.hlsearch = true

    -- enable mouse mode
    vim.o.mouse = 'a'

    -- sync clipboard between OS and nvim
    vim.o.clipboard = 'unnamedplus'

    -- disable swap
    vim.o.swapfile = false

    -- enable break indent
    vim.o.breakindent = true

    -- save undo history
    vim.o.undofile = true

    -- case-insensitive searching
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- decrease update time
    vim.o.updatetime = 1
    vim.o.timeoutlen = 1
    vim.o.ttimeoutlen = 1

    -- set completeopt to have a better completion experience
    vim.o.completeopt = 'menuone,noselect'

    -- disable key sequence timeouts
    vim.o.timeout = false
    vim.o.ttimeout = false

    -- enable GUI terminal colors
    vim.o.termguicolors = true

    -- hide fill characters
    vim.opt.fillchars = { eob = ' ' }

    -- set number line width to 1
    vim.opt.numberwidth = 1

    -- hide concealed text
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = 'nc'

    -- max scrollback size
    vim.opt.scrollback = 100000

    -- linebreak when wrapping is on
    vim.wo.linebreak = true

    -- ensure path includes subdirectories
    vim.o.path = vim.o.path .. '**'

    -- textobject for current line between whitespace
    vim.cmd'xnoremap ic g_o^'
    vim.cmd'onoremap ic :<c-u>normal! vic<cr>'

    -- automatically trim DOS line endings
    function _G.TrimPaste()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('p', true, false, true), 'n', false)
      vim.schedule(function ()
        local save = vim.fn.winsaveview()
        vim.cmd'keeppatterns %s/\\s\\+$\\|\\r$//e'
        vim.fn.winrestview(save)
      end)
    end
    vim.cmd'noremap p :lua _G.TrimPaste()<cr>'

    -- smooth scrolling
    local neoscroll = require'neoscroll'
    neoscroll.setup()
    local keymap = {
      ['<c-u>'] = function() neoscroll.ctrl_u({ duration = 100 }) end,
      ['<c-d>'] = function() neoscroll.ctrl_d({ duration = 100 }) end,
      ['<c-b>'] = function() neoscroll.ctrl_b({ duration = 150 }) end,
      ['<c-f>'] = function() neoscroll.ctrl_f({ duration = 150 }) end,
      ['<c-y>'] = function() neoscroll.scroll(-0.1, { move_cursor = false; duration = 100 }) end,
      ['<c-e>'] = function() neoscroll.scroll(0.1, { move_cursor = false; duration = 100 }) end,
      ['zt']    = function() neoscroll.zt({ half_win_duration = 100 }) end,
      ['zz']    = function() neoscroll.zz({ half_win_duration = 100 }) end,
      ['zb']    = function() neoscroll.zb({ half_win_duration = 100 }) end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end

    -- keybinds
    UseKeymap('vim_number_line', function ()
      if vim.wo.number then
        print'number line OFF'
        vim.wo.number = false
      else
        print'number line ON'
        vim.wo.number = true
      end
    end)
    UseKeymap('vim_relative_number_line', function ()
      if vim.wo.relativenumber then
        print'relative number line OFF'
        vim.wo.relativenumber = false
      else
        print'relative number line ON'
        vim.wo.relativenumber = true
      end
    end)
    UseKeymap('vim_wrap', function ()
      if vim.wo.wrap then
        print'wrap OFF'
        vim.wo.wrap = false
      else
        print'wrap ON'
        vim.wo.wrap = true
      end
    end)
    UseKeymap('vim_kill_buffers', function ()
      vim.cmd'%bd!'
      vim.cmd'echo ""'
    end)
    UseKeymap('vim_delete_buffer', function () vim.cmd'bd!' end)
    UseKeymap('vim_only_buffer', function ()
      local current_buf = vim.api.nvim_get_current_buf()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
          if vim.bo[buf].buftype ~= 'terminal' then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
    end)
    UseKeymap('vim_previous_buffer', function () vim.cmd'b#' end)
    UseKeymap('vim_trim_dos', function ()
      local save = vim.fn.winsaveview()
      vim.cmd'keeppatterns %s/\\s\\+$\\|\\r$//e'
      vim.fn.winrestview(save)
    end)
    UseKeymap('select_last_paste', function () vim.cmd'normal! `[v`]' end)
  end
}

return module

