local module = {
  name = 'terminal',
  desc = 'terminal-related commands',
  plugins = {},
}

_G.__terminals__ = {}

local function autocomplete (_, cmd)
  local args = vim.split(cmd, ' ', { plain = true, trimempty = true })
  if #args == 1 then
    return vim.tbl_keys(_G.__terminals__)
  else
    return {}
  end
end

function _G.Tgo (name)
  local job_id = _G.__terminals__[name]
  if job_id then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == 'terminal' and vim.b[buf].terminal_job_id == job_id then
        vim.api.nvim_set_current_buf(buf)
        vim.cmd'echo ""'
        return
      end
    end
  end
  Tnew(name)
end

function _G.Tnew (name)
  vim.cmd'terminal'
  Tname(name, true)
  vim.cmd'echo ""'
end

function _G.Tname(name, is_silent)
  if not name then
    print 'Error: Usage is Tname term_name'
    return
  end
  if vim.bo.buftype == 'terminal' then
    local job_id = vim.b.terminal_job_id
    local is_rename = false
    if job_id then
      for stored_name, stored_job_id in pairs(_G.__terminals__) do
        if stored_job_id == job_id then
          _G.__terminals__[stored_name] = nil
          is_rename = true
          break
        end
      end
      _G.__terminals__[name] = job_id
      if not is_silent then
        if is_rename then
          print('Terminal renamed to: ' .. name)
        else
          print('Terminal name set to: ' .. name)
        end
      end
    else
      print'Error: Could not get terminal job ID.'
    end
  else
    print'Error: Not inside a terminal buffer.'
  end
end

function _G.Twhich ()
  if vim.bo.buftype ~= 'terminal' then
    print'Error: Current buffer is not a terminal.'
    return
  end
  local job_id = vim.b.terminal_job_id
  if not job_id then
    print'Error: Could not retrieve terminal job ID.'
    return
  end
  for name, stored_job_id in pairs(_G.__terminals__) do
    if stored_job_id == job_id then
      print(name)
      return
    end
  end
  print'Error: This terminal is not named.'
end

function _G.Tlist ()
  if vim.tbl_isempty(_G.__terminals__) then
    print'Error: No named terminals exist.'
  return
  end
  for name in pairs(_G.__terminals__) do
    print(name)
  end
end

function _G.Tsend (name, command)
  local job_id = _G.__terminals__[name]
  if job_id then
    vim.fn.chansend(job_id, command .. '\r')
  else
    Tnew(name)
    vim.defer_fn(function ()
      job_id = _G.__terminals__[name]
      if job_id then
        vim.fn.chansend(job_id, command .. '\r')
      end
    end, 500)
  end
  vim.cmd'echo ""'
end

function Tclear ()
  local current_buf = vim.api.nvim_get_current_buf()
  if vim.bo[current_buf].buftype == "terminal" then
  else
    print('Error: Not in a terminal buffer.')
  end
end

module.fn = function ()
  vim.api.nvim_create_autocmd('BufDelete', {
    pattern = '*',
    callback = function (args)
      if vim.bo[args.buf].buftype == 'terminal' then
        local job_id = vim.b[args.buf].terminal_job_id
        if job_id then
          for name, id in pairs(_G.__terminals__) do
            if id == job_id then
              _G.__terminals__[name] = nil
              break
            end
          end
        end
      end
    end,
  })
  vim.api.nvim_create_user_command('Tname', function (opts)
    _G.Tname(opts.args)
  end, { nargs = 1 })
  vim.api.nvim_create_user_command('Twhich', function ()
    _G.Twhich()
  end, { nargs = 0 })
  vim.api.nvim_create_user_command('Tclear', function ()
    _G.Tclear()
  end, { nargs = 0 })
  vim.api.nvim_create_user_command('Tlist', function ()
    _G.Tlist()
  end, { nargs = 0 })
  vim.api.nvim_create_user_command('T', function (opts)
    local args = vim.split(opts.args, ' ', { plain = true, trimempty = true })
    if #args < 1 then
      return
    end
    local name = args[1]
    if args[2] then
      local command = table.concat(vim.list_slice(args, 2), ' ')
      _G.Tsend(name, command)
    else
      if __terminals__[name] then
        _G.Tgo(name)
      else
        _G.Tnew(name)
      end
    end
  end, { nargs = 1, complete = autocomplete })
end

return module

