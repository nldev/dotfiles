local module = {
  name = 'files',
  desc = 'file browsing',
  dependencies = { 'fuzzy' },
  plugins = {
    { 'echasnovski/mini.files', version = false },
  },
  fn = function ()
    local files = require('mini.files')
    files.setup({
      content = { prefix = function () end },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 60,
      },
    })
    UseKeymap('open_file_browser', function () files.open(vim.fn.getcwd()) end)
    UseKeymap('open_config_vim_autocmds', function () vim.cmd('e ~/.config/nvim/autocmds.lua') end)
    UseKeymap('open_config_vim_context', function () files.open('~/.context/nvim', false) end)
    UseKeymap('open_config_vim_fuzzy_context', function () require'fzf-lua'.files{ cwd = '~/.context/nvim' } end)
    UseKeymap('open_config_vim_modules', function () files.open('~/.config/nvim/modules', false) end)
    UseKeymap('open_config_vim_fuzzy_modules', function () require'fzf-lua'.files{ cwd = '~/.config/nvim/modules' } end)
    UseKeymap('open_config_vim_init', function () vim.cmd('e ~/.config/nvim/init.lua') end)
    UseKeymap('open_config_vim_keymaps', function () vim.cmd('e ~/.config/nvim/keymaps.lua') end)
    UseKeymap('open_config_vim_api', function () vim.cmd('e ~/.config/nvim/api.lua') end)
  end
}

return module

