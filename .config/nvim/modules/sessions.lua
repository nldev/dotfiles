local module = {
  name = 'sessions',
  desc = 'session management',
  plugins = {
    'folke/persistence.nvim',
  },
  fn = function ()
    -- Load last session.
    local persistence = require'persistence'
    persistence.setup()
    persistence.load{ last = true }

    -- Remove pre-existing terminal buffers.
    vim.defer_fn(function ()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if string.find(buf_name, 'term:') then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end, 1000)
  end,
}

return module

