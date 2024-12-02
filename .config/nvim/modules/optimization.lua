local module = {
  name = 'optimization',
  desc = 'performance improvements',
  dependencies = { 'vim' },
  plugins = { 'pteroctopus/faster.nvim' },
  fn = function ()
    require'faster'.setup()
    -- vim.api.nvim_create_autocmd('BufReadPost', {
    --   callback = function ()
    --     if vim.fn.exists':NeoscrollEnableBufferPM' == 2 then
    --       local line_count = vim.fn.line'$'
    --       if line_count > 5000 then
    --         vim.cmd'NeoscrollEnableBufferPM'
    --       end
    --     end
    --   end,
    --   desc = 'Enable Neoscroll performance mode for buffers with more than 5000 lines',
    -- })
  end,
}

return module

