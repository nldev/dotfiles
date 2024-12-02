local module = {
  name = 'editing',
  desc = 'text editing enhancements',
  dependencies = { 'files', 'quickfix' },
  plugins = {
    -- Single-line <-> Multiline code
    { 'echasnovski/mini.splitjoin', version = false },

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
    -- virtual edit for visual block mode
    vim.opt.virtualedit = 'block'

    -- pear-tree
    vim.cmd'let g:pear_tree_smart_openers = 1'
    vim.cmd'let g:pear_tree_smart_closers = 1'
    vim.cmd'let g:pear_tree_smart_backspace = 1'
    vim.cmd'let g:pear_tree_map_special_keys = 0'
    vim.cmd'imap <BS> <Plug>(PearTreeBackspace)'

    -- mini.surround
    require'mini.surround'.setup{
      mappings = {
       add = 'Sa',
       delete = 'Sd',
       find = 'Sf',
       find_left = 'SF',
       highlight = 'Sh',
       replace = 'Sr',
       suffix_last = '',
       suffix_next = '',
       update_n_lines = '',
     },
    }

    -- mini.splitjoin
    local splitjoin = require'mini.splitjoin'
    splitjoin.setup{
      mappings = {
        toggle = '',
        split = '',
        join = '',
      },
    }
    UseKeymap('splitjoin', function () splitjoin.toggle() end)

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
    vim.keymap.set('v', '<c-j>', function()
      local count = vim.v.count1  -- Get the count or default to 1
      return ":move '>+" .. count .. '<cr>gv=gv'
    end, { expr = true, silent = true })
    vim.keymap.set('v', '<c-k>', function()
      local count = vim.v.count1
      return ":move '<-" .. (count + 1) .. '<cr>gv=gv'
    end, { expr = true, silent = true })

    -- fix whitespace
    UseKeymap('fix_whitespace', function ()
      vim.cmd'retab'
      vim.cmd'%s/\\s\\+$//e'
    end)

    -- remove empty lines
    vim.cmd[[ command! -range=% RemoveEmptyLines :<line1>,<line2>s/^\s*\n//g | noh ]]
    UseKeymap('remove_empty_lines', function () vim.cmd'RemoveEmptyLines' end)
  end,
}

return module

