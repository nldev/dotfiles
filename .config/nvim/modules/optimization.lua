local module = {
  name = 'optimization',
  desc = 'performance improvements',
  plugins = {
    'pteroctopus/faster.nvim',
  },
  fn = function ()
    require'faster'.setup()
  end,
}

return module

