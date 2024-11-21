local module = {
  name = 'files',
  desc = 'file browsing',
  dependencies = { 'search' },
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
    local function create_temp_file (extension, filetype)
      local timestamp = os.date'%Y%m%d-%H%M%S'
      local filepath = string.format('/tmp/%s.%s', timestamp, extension)
      vim.cmd('e ' .. filepath)
      vim.bo.filetype = filetype
    end
    UseKeymap('empty_file', function () create_temp_file('txt', 'text') end)
    UseKeymap('empty_json_file', function () create_temp_file('json', 'json') end)
    UseKeymap('empty_lua_file', function () create_temp_file('lua', 'lua') end)
    UseKeymap('empty_vim_file', function () create_temp_file('vim', 'vim') end)
    UseKeymap('search_config', function () require'telescope.builtin'.find_files{ cwd = '~/.config' } end)
    UseKeymap('search_vim_context', function () require'telescope.builtin'.find_files{ cwd = '~/.context/nvim' } end)
    UseKeymap('search_vim_modules', function () require'telescope.builtin'.find_files{ cwd = '~/.config/nvim/modules' } end)
    UseKeymap('open_config', function () files.open('~/.config', false) end)
    UseKeymap('open_config_vim_api', function () vim.cmd'e ~/.config/nvim/api.lua' end)
    UseKeymap('open_config_vim_autocmds', function () vim.cmd'e ~/.config/nvim/autocmds.lua' end)
    UseKeymap('open_config_vim_context', function () files.open('~/.context/nvim', false) end)
    UseKeymap('open_config_vim_init', function () vim.cmd'e ~/.config/nvim/init.lua' end)
    UseKeymap('open_config_vim_keymaps', function () vim.cmd'e ~/.config/nvim/keymaps.lua' end)
    UseKeymap('open_config_vim_modules', function () files.open('~/.config/nvim/modules', false) end)
    UseKeymap('open_dev', function () files.open('~/dev', false) end)
    UseKeymap('open_file_browser', function () files.open(vim.api.nvim_buf_get_name(0), false) end)
    UseKeymap('open_home', function () files.open('~', false) end)
    UseKeymap('open_persistent_file_browser', function () files.open(vim.fn.getcwd()) end)
    UseKeymap('open_project_browser', function () files.open(vim.fn.getcwd(), false) end)
    UseKeymap('open_root', function () files.open('/', false) end)
    UseKeymap('open_temp', function () files.open('/tmp', false) end)
  end
}

return module

