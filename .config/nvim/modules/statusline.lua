local module = {
  name = 'statusline',
  desc = 'configures the status line',
  plugins = {},
  dependencies = { 'git' },
}

local function status_simple ()
  -- reset status line
  vim.opt.statusline = ''

  -- file path and modified flag
  vim.opt.statusline:append'%f '
end

local function status_normal ()
  -- reset status line
  vim.opt.statusline = ''

  -- file path and modified flag
  vim.opt.statusline:append'%f%m '

  -- git branch name (only if inside repo)
  vim.opt.statusline:append'%{get(b:,"gitsigns_head","") != "" ? "<".get(b:,"gitsigns_head","").">" : ""} '

  -- git status
  vim.opt.statusline:append'%{get(b:,"gitsigns_status","")}'

  -- right-align remaining statusline
  vim.opt.statusline:append'%='

  -- buffer language
  vim.opt.statusline:append'%{!empty(&filetype) ? &filetype : &buftype} '

  -- hex value of char under cursor
  -- vim.opt.statusline:append'[0x%B] '

  -- buffer number
  -- vim.opt.statusline:append'B:%n '

  -- column number
  -- vim.opt.statusline:append'C:%v '

  -- line / column
  vim.opt.statusline:append'%l:%v '

  -- current line / total lines
  -- vim.opt.statusline:append'L:%l/%L '

  -- percentage through the file
  -- vim.opt.statusline:append'[%p%%]'
  vim.opt.statusline:append'%p%% '
end

module.fn = function ()
  -- Use a global statusline.
  vim.cmd('set laststatus=3')
  -- :StatusNormal
  vim.api.nvim_create_user_command('StatusNormal', function ()
    status_normal()
    vim.cmd('echo ""')
  end, { nargs = 0 })
  -- :StatusSimple
  vim.api.nvim_create_user_command('StatusSimple', function ()
    status_simple()
    vim.cmd('echo ""')
  end, { nargs = 0 })
  -- Set default statusline.
  status_normal()
end

return module

