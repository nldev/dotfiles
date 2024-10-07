local module = {
  name = 'comments',
  desc = 'functionalities related to commenting code',
  plugins = {
    {
      'folke/todo-comments.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
  },
}

local auto_comments = false

local toggle_auto_comments = function ()
  auto_comments = not auto_comments
  if auto_comments then
    vim.opt_local.formatoptions = table.concat(vim.opt_local.formatoptions:get(), '') .. 'cro'
    print('auto-comments ON')
  else
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    print('auto-comments OFF')
  end
end

module.fn = function ()
  require'todo-comments'.setup{
    signs = false,
    highlight = {
      multiline = false,
    },
    keywords = {
      FIXME = { icon = '', color = 'error' },
      TODO = { icon = '', color = 'warn' },
      HACK = { icon = '', color = 'warn' },
      WARN = { icon = '', color = 'warn' },
      NOTE = { icon = '', color = 'info' },
      TEST = { icon = '', color = 'hint' },
    },
    colors = {
      error = { 'DiagnosticError' },
      warn = { 'DiagnosticWarn' },
      info = { 'DiagnosticInfo' },
      hint = { 'DiagnosticHint' },
    },
  }
  UseKeymap('toggle_auto_comments', function () toggle_auto_comments() end)
  UseAutocmd('no_auto_comments', function ()
    if not auto_comments then
      vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end
  end)
end

return module

