local module = {
  name = 'movement',
  desc = 'vim movement stuff',
  plugins = {
    'chrisgrieser/nvim-spider',
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
    require'spider'.setup()
    vim.keymap.set({ 'n', 'o', 'x' }, 'w', '<cmd>lua require"spider".motion"w"<cr>', { desc = 'Spider w' })
    vim.keymap.set({ 'n', 'o', 'x' }, 'e', '<cmd>lua require"spider".motion"e"<cr>', { desc = 'Spider e' })
    vim.keymap.set({ 'n', 'o', 'x' }, 'b', '<cmd>lua require"spider".motion"b"<cr>', { desc = 'Spider b' })
    UseKeymap('jump', function () require'flash'.jump() end)
    UseKeymap('jump_treesitter', function () require'flash'.treesitter() end)
  end
}

return module

