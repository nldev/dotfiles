local module = {
  name = 'number-line',
  desc = 'configuration for number line',
  plugins = {},
  fn = function ()
    -- Ensure number line is on by default.
    vim.wo.number = true

    -- Ensure relative number line is off by default.
    vim.wo.relativenumber = false

    -- Use relative number line in visual mode.
    -- FIXME: should use UseAutocmd
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

    -- Do not use relative number line in normal or insert mode.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('ModeChanged', {
      pattern = { '*:n', '*:i' },
      callback = function ()
        vim.opt.relativenumber = false
      end,
    })

    -- Disable number line in terminal buffers.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function ()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })

    -- Disable number line in text buffers.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function ()
        vim.wo.relativenumber = false
        if vim.bo.buftype == '' then
          vim.wo.number = true
        end
        if vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text' then
          vim.wo.number = false
        end
      end,
    })

    -- Enable number line in text and terminal buffers when in visual mode.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
      pattern = { 'n:v', 'v:n', 'n:V', 'V:n', 'n:\22', '\22:n' },
      callback = function ()
        if vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text' or vim.bo.buftype == 'terminal' then
          vim.wo.number = true
          vim.wo.relativenumber = true
        end
      end,
    })

    -- Disable number line in text and terminal buffers when in normal or insert mode.
    -- FIXME: should use UseAutocmd
    vim.api.nvim_create_autocmd('ModeChanged', {
      pattern = { '*:n', '*:i' },
      callback = function ()
        if vim.bo.filetype == 'markdown' or vim.bo.filetype == 'text' or vim.bo.buftype == 'terminal' then
          vim.opt.number = false
          vim.opt.relativenumber = false
        end
      end,
    })
  end
}

return module

