local module = {
  name = 'autosave',
  desc = 'defines an autosave autocmd',
  plugins = {},
  fn = function ()
    -- FIXME: fix this
    -- UseAutocmd('autosave', function ()
    --   local current_buf = vim.api.nvim_get_current_buf()
    --   local bufnr_list = vim.api.nvim_list_bufs()
    --   for _, bufnr in ipairs(bufnr_list) do
    --     local buf_name = vim.api.nvim_buf_get_name(bufnr)
    --     local is_modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
    --     if vim.api.nvim_buf_is_loaded(bufnr) and is_modified and buf_name ~= "" then
    --       if vim.loop.fs_stat(buf_name) then
    --         vim.api.nvim_buf_call(bufnr, function ()
    --           vim.cmd('silent! update')
    --         end)
    --       end
    --     end
    --   end
    --   vim.api.nvim_set_current_buf(current_buf)
    -- end)
  end,
}

return module

