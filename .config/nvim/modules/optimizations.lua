local module = {
  name = 'optimizations',
  desc = 'performance improvements',
  plugins = {
    'pteroctopus/faster.nvim',
  },
  fn = function ()
    require('faster').setup()
  end
}

return module

