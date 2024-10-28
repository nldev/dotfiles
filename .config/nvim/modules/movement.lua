local module = {
  name = 'movement',
  desc = 'vim movement stuff',
  plugins = {
    {
      'folke/flash.nvim',
      opts = {
        highlight = { backdrop = false },
        modes = {
          char = { enabled = false },
          search = { enabled = true },
        },
      },
    },
  },
  fn = function ()
    local flash = require'flash'
    UseKeymap('jump', function () flash.jump() end)
    UseKeymap('jump_treesitter', function () flash.treesitter() end)
  end
}

return module

