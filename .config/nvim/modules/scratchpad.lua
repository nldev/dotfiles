local module = {
  name = 'scratchpad',
  desc = 'scratch window utility',
  dependencies = { 'commands' },
  plugins = {},
}

local previous_window = nil
local layout = nil
local scratch_file = vim.fn.expand'~/.local/share/nvim/scratch.txt'

function _G.Scratchpad (same_window)
  local current_file = vim.api.nvim_buf_get_name(0)
  local total_lines = vim.o.lines
  local run = 'edit ' .. scratch_file
  local scratch_win = nil

  if same_window then
    if current_file == scratch_file then
      local buffer = vim.api.nvim_get_current_buf()
      vim.cmd'silent! bprev!'
      vim.api.nvim_buf_delete(buffer, { force = true })
    else
      vim.cmd(run)
    end
    return
  end

  -- Close quickfix window since it breaks the scratch window.
  -- TODO: figure out why this is even needed
  vim.cmd'cclose'

  -- Find scratch window if it exists.
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == scratch_file then
      scratch_win = win
      break
    end
  end

  -- Close scratch window if it exists and is not the current window.
  if scratch_win and scratch_win ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(scratch_win)
    vim.cmd'write'
    vim.cmd'bdelete'
    if layout then
      vim.cmd(layout)
      layout = nil
    end
    if previous_window then
      vim.api.nvim_set_current_win(previous_window)
    end
    vim.cmd'echo ""'
    return
  end

  -- Close scratch window if it is the current window.
  if current_file == scratch_file then
    vim.cmd'write'
    vim.cmd'bdelete'
    if layout then
      vim.cmd(layout)
      layout = nil
    end
    if previous_window and vim.api.nvim_win_is_valid(previous_window) then
      vim.api.nvim_set_current_win(previous_window)
    end
    vim.cmd'echo ""'
    return
  end

  -- Resize function
  local function resize ()
    local amount = math.max(1, math.min(
      vim.o.lines / 2,
      vim.api.nvim_buf_line_count(0)
    ))
    vim.cmd('resize ' .. amount)
    vim.cmd'Z'
  end

  -- Open scratch window if it isn't already open.
  layout = vim.fn.winrestcmd()
  previous_window = vim.api.nvim_get_current_win()
  if total_lines <= 25 then
    vim.cmd(run)
  else
    vim.cmd'split'
    vim.cmd'wincmd K'
    vim.cmd('edit ' .. scratch_file)
    resize()
  end

  -- Set height of scratch buffer while editing.
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    pattern = '/home/user/.local/share/nvim/scratch.txt',
    callback = function ()
      if vim.o.lines > 25 then
        resize()
      end
    end,
  })
end

module.fn = function ()
  UseKeymap('scratchpad', function () _G.Scratchpad() end)
  UseKeymap('scratchpad_current_buffer', function () _G.Scratchpad(true) end)
end

return module

