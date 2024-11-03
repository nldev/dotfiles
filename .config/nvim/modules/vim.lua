local module = {
  name = 'vim',
  desc = 'general settings',
  plugins = {},
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

    -- max scrollback size
    vim.opt.scrollback = 100000

    -- keybinds
    UseKeymap('vim_quit', function ()
      vim.cmd'cclose'
      vim.cmd'qa!'
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
  end
}

return module

