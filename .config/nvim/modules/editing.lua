local module = {
  name = 'editing',
  desc = 'text editing enhancements',
  dependencies = { 'files', 'quickfix', 'intellisense' },
  plugins = {
    -- Automatic pair insertion
    'tmsvg/pear-tree',

    -- Surround operations
    { 'echasnovski/mini.surround', version = false },

    -- Toggle characters at end of line
    {
      'saifulapm/commasemi.nvim',
      opts = { commands = true },
    },

    -- Abbreviate / substitute / coerce with multiple variants
    'tpope/vim-abolish',
  },
  fn = function ()
    -- pear-tree
    vim.g.pear_tree_smart_openers = 1
    vim.g.pear_tree_smart_closers = 1
    vim.g.pear_tree_smart_backspace = 1
    vim.g.pear_tree_map_special_keys = 0
    vim.g.pear_tree_ft_disabled = { 'TelescopePrompt' }
    vim.cmd[[
    imap <BS> <Plug>(PearTreeBackspace)
    autocmd FileType TelescopePrompt imap <buffer> <BS> <BS>
    ]]

    -- mini.surround
    require'mini.surround'.setup{
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        suffix_last = '',
        suffix_next = '',
        update_n_lines = '',
      },
    }

    -- smart comma
    UseKeymap('smart_comma', function ()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local fixed = col + 1
      local last_char_before = fixed > 0 and line:sub(fixed, fixed) or ''
      local first_char_after = line:sub(fixed + 1, fixed + 1)
      if (last_char_before == "'" or last_char_before == '"' or last_char_before == '`') and last_char_before == first_char_after then
        local insert_pos = fixed + 1
        local new_line = line:sub(1, insert_pos) .. ', ' .. line:sub(insert_pos + 1)
        vim.api.nvim_set_current_line(new_line)
        vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(0)[1], insert_pos + 2})
        return
      end
      local before_cursor = line:sub(1, col)
      local after_cursor = line:sub(col + 1)
      local open_quote = before_cursor:match'.*([\'"`])[^\'"`]*$'
      local close_quote_pos = open_quote and after_cursor:find(open_quote)
      if open_quote and close_quote_pos then
        local insert_pos = col + close_quote_pos
        vim.api.nvim_set_current_line(before_cursor .. after_cursor:sub(1, close_quote_pos) .. ', ' .. after_cursor:sub(close_quote_pos + 1))
        vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], insert_pos + 2 })
      else
        local word_end = after_cursor:match'^%w*'
        local insert_pos = col + #word_end + 1
        vim.api.nvim_set_current_line(before_cursor .. word_end .. ', ' .. after_cursor:sub(#word_end + 1))
        vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], insert_pos + 1 })
      end
    end)

    -- write file
    UseKeymap('write_file', function ()
      if vim.bo.filetype == 'minifiles' then
        require'mini.files'.synchronize()
        return
      end
      local buf = vim.api.nvim_get_current_buf()
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local is_writable = vim.bo[buf].modifiable and vim.bo[buf].modifiable
      if buf_name == '' then
        return
      elseif not is_writable then
        return
      end
      vim.cmd'w'
      vim.cmd'echo ""'
    end)

    -- black hole operations
    UseKeymap('black_hole_delete', function ()
      vim.api.nvim_feedkeys('"_d', 'x', false)
    end)
    UseKeymap('black_hole_paste', function ()
      vim.api.nvim_feedkeys('"_dhp', 'x', false)
    end)

    -- insert mode EOL insertions
    UseKeymap('toggle_eol_comma', function () vim.cmd'CommaToggle' end)
    UseKeymap('toggle_eol_semicolon', function () vim.cmd'SemiToggle' end)

    -- move lines
    vim.keymap.set('v', '<m-j>', function ()
      local count = vim.v.count1  -- Get the count or default to 1
      return ":move '>+" .. count .. '<cr>gv=gv'
    end, { expr = true, silent = true })
    vim.keymap.set('v', '<m-k>', function()
      local count = vim.v.count1
      return ":move '<-" .. (count + 1) .. '<cr>gv=gv'
    end, { expr = true, silent = true })

    -- fix whitespace
    UseKeymap('fix_whitespace', function ()
      vim.cmd'retab'
      vim.cmd'%s/\\s\\+$//e'
    end)

    -- insert blank lines
    UseKeymap('insert_blank_above', function ()
      vim.cmd'put! _'
      vim.cmd'norm j'
    end)
    UseKeymap( 'insert_blank_below', function ()
      vim.cmd'put _'
      vim.cmd'norm k'
    end)

    -- delete above / below
    UseKeymap('delete_below', function ()
      local saved_pos = vim.fn.winsaveview()
      vim.cmd'norm jddk'
      vim.fn.winrestview(saved_pos)
    end)
    UseKeymap('delete_above', function ()
      vim.cmd'norm kdd'
    end)

    -- remove empty lines
    -- FIXME: use UseKeymap
    vim.cmd[[
    xnoremap <silent> <leader>ee :RemoveEmptyLines<cr>
    command! -range RemoveEmptyLines silent! <line1>,<line2>s/^\s*\n//g | noh
    ]]
    local function remove_empty_lines ()
      local mode = vim.api.nvim_get_mode().mode
      if mode:match'^v' then
        vim.cmd'RemoveEmptyLines'
        return
      end
      local cursorPos = unpack(vim.api.nvim_win_get_cursor(0))
      local is_top = cursorPos == 1
      local is_blank_top = false
      local current = vim.api.nvim_get_current_line()
      local is_empty = current:match'^%s*$'
      if not is_empty then
        return
      end
      while not is_blank_top do
        current = vim.api.nvim_get_current_line()
        is_empty = current:match'^%s*$'
        if is_empty and not is_top then
          if is_empty then
            vim.cmd'norm "_ddk'
          end
        else
          is_blank_top = true
        end
        if not is_empty or is_top then
          is_blank_top = true
        end
      end
      vim.cmd'norm j'
      current = vim.api.nvim_get_current_line()
      is_empty = current:match'^%s*$'
      if not is_empty then
        return
      end
      local loc = vim.api.nvim_buf_line_count(0)
      local is_bottom = loc == cursorPos
      local is_blank_bottom = false
      while not is_blank_bottom do
        current = vim.api.nvim_get_current_line()
        is_empty = current:match'^%s*$'
        if is_empty and not is_bottom then
          if is_empty then vim.cmd'norm "_dd' end
        end
        if not is_empty or is_bottom then
          is_blank_bottom = true
        end
      end
    end
    UseKeymap('remove_empty_lines', function ()
      remove_empty_lines()
    end)
    UseKeymap('single_empty_line', function ()
      remove_empty_lines()
      vim.cmd'put! _'
    end)
    -- msdos remover
    UseKeymap('msdos_remover', function ()
      pcall(vim.cmd, ':%s/\r//g')
      vim.cmd'nohlsearch'
    end)
    -- revert buffer
    UseKeymap('revert_buffer', function ()
      local saved_pos = vim.fn.winsaveview()
      vim.cmd'e!'
      vim.fn.winrestview(saved_pos)
    end)

    -- splitjoin
    UseKeymap('split', function ()
      require'treesj'.split()
      vim.cmd'echo ""'
    end)
    UseKeymap('join', function ()
      require"treesj".join()
      vim.cmd'echo ""'
    end)

    -- delete forward
    UseKeymap('delete_forward', function ()
      vim.cmd'norm! x'
    end)

    -- replace
    UseKeymap('replace', function ()
      vim.ui.input({ prompt = 'Replace: ', default = '', cancelreturn = nil }, function (text)
        if text and #text > 0 then
          vim.cmd(string.format("%%s//%s", text))
        end
      end)
    end)

    -- rename
    UseKeymap('rename', function ()
      local current_name = vim.fn.expand'<cword>'
      vim.ui.input({ prompt = 'Rename ' .. current_name .. ': ', default = '', cancelreturn = nil }, function (name)
        if name and #name > 0 then
          vim.lsp.buf.rename(name)
          vim.cmd'echo ""'
        end
      end)
    end)

    -- redirect
    local letter = ''
    UseKeymap('redirect', function ()
      if letter == '' then
        local char = vim.fn.nr2char(vim.fn.getchar())
        if char:match'^[a-zA-Z]$' then
          letter = char
          print('redirecting messages to @' .. letter)
          vim.cmd('redir! @' .. letter)
        else
          letter = ''
        end
      else
        vim.cmd'redir END'
        print'stopped redirecting messages'
        letter = ''
      end
    end)

    -- nuke
    UseKeymap('nuke', function () vim.cmd'silent! norm! ggVGx' end)
  end,
}

return module

