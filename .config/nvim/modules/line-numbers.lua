local module = {
  name = 'line-numbers',
  desc = 'configuration for line numbers',
  plugins = {},
  fn = function ()
    -- Ensure line numbers are on by default.
    vim.wo.number = true

    -- Use relative numbers in visual mode.
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

    -- Do not use relative numbers in normal or insert mode.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('ModeChanged', {
      pattern = { '*:n', '*:i' },
      callback = function ()
        vim.opt.relativenumber = false
      end,
    })

    -- Disable line numbers in terminal buffers.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function ()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })

    -- Disable line numbers in markdown buffers.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function ()
        vim.wo.relativenumber = false
        if vim.bo.buftype == '' then
          vim.wo.number = true
        end
        if vim.bo.filetype == 'markdown' then
          vim.wo.number = false
        end
      end,
    })
  end
}

return module

