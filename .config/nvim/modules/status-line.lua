local module = {
  name = 'status-line',
  desc = 'configures the status line',
  plugins = {},
  dependencies = { 'git', 'terminal' },
}

function _G.GetBufferName ()
  if vim.bo.buftype == 'terminal' then
    local job_id = vim.b.terminal_job_id
    if job_id then
      for name, stored_job_id in pairs(_G.__terminals__) do
        if stored_job_id == job_id then
          return 'term:' .. name
        end
      end
    end
  end
  local full_path = vim.fn.expand'%:p'
  local notes_dir = vim.fn.expand'~/notes'
  if full_path:sub(1, #notes_dir) == notes_dir then
    return full_path:sub(#notes_dir + 2)
  end
  return vim.fn.expand'%f'
end

local function status_simple ()
  -- reset status line
  vim.opt.statusline = ''

  -- hide command
  vim.o.showcmd = false

   -- file path and modified flag
  vim.opt.statusline:append'%f '
end

local function status_normal ()
  -- hide command
  vim.o.showcmd = true

  -- reset status line
  vim.opt.statusline = ''

  -- buffer name
  vim.opt.statusline:append'%{v:lua.GetBufferName()}'

  -- modified status
  vim.opt.statusline:append'%m'

  -- git branch name (only if inside repo)
  vim.opt.statusline:append' %{get(b:,"gitsigns_head","") != "" ? "<".get(b:,"gitsigns_head","").">" : ""}'

  -- git status
  vim.opt.statusline:append' %{get(b:,"gitsigns_status","")}'

  -- right-align remaining statusline
  vim.opt.statusline:append'%='

  -- buffer language
  vim.opt.statusline:append'%{!empty(&filetype) ? &filetype : &buftype}'

  -- hex char under cursor
  vim.opt.statusline:append' 0x%B'

  -- column
  vim.opt.statusline:append' %v'

  -- percentage through the file
  vim.opt.statusline:append' %p%%'
end

module.fn = function ()
  -- Use a global statusline.
  vim.cmd'set laststatus=3'
  -- :StatusNormal
  vim.api.nvim_create_user_command('StatusNormal', function ()
    status_normal()
    vim.cmd'echo ""'
  end, { nargs = 0 })
  -- :StatusSimple
  vim.api.nvim_create_user_command('StatusSimple', function ()
    status_simple()
    vim.cmd'echo ""'
  end, { nargs = 0 })
  -- Set default statusline.
  status_normal()
end

return module

