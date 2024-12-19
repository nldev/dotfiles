local module = {
  name = 'movement',
  desc = 'vim movement stuff',
  plugins = {
    -- 'chrisgrieser/nvim-spider',
    {
      'folke/flash.nvim',
      opts = {
        highlight = { backdrop = false },
        modes = {
          char = { enabled = false },
          search = { enabled = false },
        },
      },
    },
  },
  fn = function ()
    local flash = require'flash'
    -- local spider = require'spider'
    -- spider.setup{
    --   skipInsignificantPunctuation = false,
    --   consistentOperatorPending = false,
    -- }
    -- vim.keymap.set({ 'n', 'o', 'x' }, 'w', function () spider.motion'w' end, { desc = 'Spider w' })
    -- vim.keymap.set({ 'n', 'o', 'x' }, 'e', function () spider.motion'e' end, { desc = 'Spider e' })
    -- vim.keymap.set({ 'n', 'o', 'x' }, 'b', function () spider.motion'b' end, { desc = 'Spider b' })
    UseKeymap('jump', function () flash.jump() end)
    UseKeymap('jump_treesitter', function () flash.treesitter() end)
  end
}

return module

