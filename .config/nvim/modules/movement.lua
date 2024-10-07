local module = {
  name = 'movement',
  desc = 'code navigation stuff',
  plugins = {
    {
      'folke/flash.nvim',
      opts = {
        modes = {
          char = { enabled = false },
        },
      },
    },
  },
  fn = function ()
    UseKeymap('jump', function () require'flash'.jump() end)
    UseKeymap('jump_treesitter', function () require'flash'.treesitter() end)
  end
}

return module

