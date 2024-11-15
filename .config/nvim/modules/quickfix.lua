local module = {
  name = 'quickfix',
  desc = 'quickfix list improvement',
  dependencies = { 'intellisense' },
  plugins = {
    'kevinhwang91/nvim-bqf',
    'stevearc/quicker.nvim',
    'romainl/vim-qf',
  },
  fn = function ()
    require'quicker'.setup()
    require'bqf'.setup{
      func_map = {
        split = '_',         -- <c-x>
        vsplit = '|',        -- <c-v>
        pscrollup = '',      -- <c-b>
        pscrolldown = '',    -- <c-f>
        -- open = '',        -- <cr>
        -- openc = '',       -- o
        -- drop = '',        -- O
        -- tabdrop = '',     --
        -- tab = '',         -- t
        -- tabb = '',        -- T
        -- tabc = '',        -- <c-t>
        -- prevfile = '',    -- <c-p>
        -- nextfile = '',    -- <c-n>
        -- prevhist = '',    -- <
        -- nexthist = '',    -- >
        -- lastleave = '',   -- '"
        -- stoggleup = '',   -- <s-tab>
        -- stoggledown = '', -- <tab>
        -- stogglevm = '',   -- <tab>
        -- stogglebuf = '',  -- '<tab>
        -- sclear = '',      -- z<tab>
        -- pscrollorig = '', -- zo
        -- ptogglemode = '', -- zp
        -- ptoggleitem = '', -- p
        -- ptoggleauto = '', -- P
        -- filter = '',      -- zn
        -- filterr = '',     -- zN
        -- fzffilter = '',   -- zf
      },
    }
    UseKeymap('qf_toggle', function ()
        for _, win in ipairs(vim.fn.getwininfo()) do
          if win.quickfix == 1 then
            vim.cmd'cclose'
            return
          end
        end
        vim.cmd'copen'
        vim.cmd'wincmd J'
        vim.cmd'wincmd p'
    end)
    UseKeymap('qf_open', function ()
      local qf_open = false
      for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
          qf_open = true
          vim.api.nvim_set_current_win(win.winid)
          break
        end
      end
      if not qf_open then
        vim.cmd'copen'
      end
    end)
    UseKeymap('qf_close', function () vim.cmd'cclose' end)
    UseKeymap('qf_next', function () pcall(vim.cmd, 'cn') end)
    UseKeymap('qf_previous', function () pcall(vim.cmd, 'cp') end)
    UseKeymap('qf_first', function () vim.cmd'cfirst' end)
    UseKeymap('qf_last', function () vim.cmd'clast' end)
    UseKeymap('qf_add', function ()
      vim.fn.setqflist({
        {
          filename = vim.fn.expand'%',
          lnum = vim.fn.line'.',
          col = vim.fn.col'.',
          text = vim.fn.getline'.',
        },
      }, 'a')
      vim.cmd'copen'
      vim.cmd'wincmd p'
    end)
    UseKeymap('qf_diagnostics', function ()
      local bufnr = vim.api.nvim_get_current_buf()
      local diagnostics = vim.diagnostic.get(bufnr)
      local items = {}
      for _, diag in ipairs(diagnostics) do
        table.insert(items, {
          bufnr = bufnr,
          lnum = diag.lnum + 1,
          col = diag.col + 1,
          text = diag.message,
          type = diag.severity == vim.diagnostic.severity.ERROR and 'E' or 'W',
        })
      end
      vim.fn.setqflist(items, 'r')
      vim.cmd'copen'
    end)
    UseKeymap('qf_all_diagnostics', function ()
      vim.diagnostic.setqflist{ open = false }
      vim.cmd'copen'
    end)
    UseKeymap('qf_clear', function ()
      vim.fn.setqflist{}
      vim.cmd'cclose'
    end)
    UseKeymap('qf_go', function ()
      vim.cmd'cc'
    end)
    UseKeymap('qf_delete', function ()
      local qf_was_selected = false
      local qf_win_id = nil
      for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
          qf_win_id = win.winid
          if vim.api.nvim_get_current_win() == qf_win_id then
            qf_was_selected = true
          end
          break
        end
      end
      local index = vim.fn.getqflist{ idx = 0 }.idx
      vim.cmd'copen'
      if #vim.fn.getqflist() == 1 then
        vim.fn.setqflist{}
      else
        vim.api.nvim_command'normal! dd'
        vim.cmd'w'
      end
      vim.fn.setqflist({}, 'r', { idx = index })
      if #vim.fn.getqflist() == 0 then
        vim.cmd'cclose'
      elseif not qf_was_selected then
        vim.cmd'wincmd p'
      end
    end)
  end
}

return module

