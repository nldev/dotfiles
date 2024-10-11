local module = {
  name = 'line-numbers',
  desc = 'configuration for line numbesr',
  plugins = {},
  fn = function ()
    -- make line numbers default
    vim.wo.number = true

    -- use relative number in visual modes
    vim.wo.relativenumber = false
    vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
      pattern = { 'n:v', 'v:n', 'n:V', 'V:n', 'n:\22', '\22:n' },
      callback = function ()
        if not vim.wo.number then
          vim.wo.relativenumber = false
          return
        end
        vim.wo.relativenumber = not not vim.fn.mode():match('[vV\22]')
      end,
    })

    -- disable line numbers in terminal buffers
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })

    -- enable line numbers for regular file buffers
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        vim.wo.relativenumber = false
        if vim.bo.buftype == '' then
          vim.wo.number = true
        end
      end,
    })
  end
}

return module

