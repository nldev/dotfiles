local module = {
  name = 'editing',
  desc = 'text editing enhancements',
  dependencies = { 'files' },
  plugins = {
    -- Single-line <-> Multiline code
    { 'echasnovski/mini.splitjoin', version = false },

    -- Automatic pair insertion
    { 'echasnovski/mini.pairs', version = false },

    -- Surround operations
    { 'echasnovski/mini.surround', version = false },

    -- Toggle characters at end of line
    {
      'saifulapm/chartoggle.nvim',
      opts = {
        leader = ',',
        keys = { ',', ';', '.', ':' },
      },
    },
  },
  fn = function ()
    -- virtual edit for visual block mode
    -- vim.opt.virtualedit = 'block'

    -- mini.pairs
    require'mini.pairs'.setup()

    -- mini.surround
    require'mini.surround'.setup{
      mappings = {
       add = 'Sa',
       delete = 'Sd',
       find = 'Sf',
       find_left = 'SF',
       highlight = 'Sh',
       replace = 'Sr',
       update_n_lines = '',
       suffix_last = '',
       suffix_next = '',
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
      local open_quote = before_cursor:match('.*([\'"`])[^\'"`]*$')
      local close_quote_pos = open_quote and after_cursor:find(open_quote)
      if open_quote and close_quote_pos then
        local insert_pos = col + close_quote_pos
        vim.api.nvim_set_current_line(before_cursor .. after_cursor:sub(1, close_quote_pos) .. ', ' .. after_cursor:sub(close_quote_pos + 1))
        vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], insert_pos + 2 })
      else
        local word_end = after_cursor:match('^%w*')
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
      vim.cmd('w')
    end)
  end,
}

return module

