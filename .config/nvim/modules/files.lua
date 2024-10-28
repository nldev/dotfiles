local module = {
  name = 'files',
  desc = 'file browsing',
  dependencies = { 'fuzzy' },
  plugins = {
    { 'echasnovski/mini.files', version = false },
  },
  fn = function ()
    local files = require'mini.files'
    files.setup{
      content = { prefix = function () end },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 60,
      },
      options = {
        use_as_default_explorer = false,
      },
    }
    UseKeymap('empty_file', function () vim.cmd'enew | set filetype=text' end)
    UseKeymap('empty_json_file', function () vim.cmd'enew | set filetype=json' end)
    UseKeymap('open_file_browser', function () files.open(vim.api.nvim_buf_get_name(0), false) end)
    UseKeymap('open_persistent_file_browser', function () files.open(vim.fn.getcwd()) end)
    UseKeymap('open_home', function () files.open'~' end)
    UseKeymap('open_dev', function () files.open'~/dev' end)
    UseKeymap('open_config', function () files.open'~/.config' end)
    UseKeymap('fuzzy_config', function () require'fzf-lua'.files{ cwd = '~/.config' } end)
    UseKeymap('open_config_vim_autocmds', function () vim.cmd'e ~/.config/nvim/autocmds.lua' end)
    UseKeymap('open_config_vim_context', function () files.open('~/.context/nvim', false) end)
    UseKeymap('fuzzy_vim_context', function () require'fzf-lua'.files{ cwd = '~/.context/nvim' } end)
    UseKeymap('open_config_vim_modules', function () files.open('~/.config/nvim/modules', false) end)
    UseKeymap('fuzzy_vim_modules', function () require'fzf-lua'.files{ cwd = '~/.config/nvim/modules' } end)
    UseKeymap('open_config_vim_init', function () vim.cmd'e ~/.config/nvim/init.lua' end)
    UseKeymap('open_config_vim_keymaps', function () vim.cmd'e ~/.config/nvim/keymaps.lua' end)
    UseKeymap('open_config_vim_api', function () vim.cmd'e ~/.config/nvim/api.lua' end)
  end
}

return module

