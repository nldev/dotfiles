--- FIXME: Bug causes tabs to close when scratchpad is opened.
local module = {
  name = 'scratchpad',
  desc = 'scratch window utility',
  plugins = {},
}

local previous_window = nil
local saved_layout = nil
-- local scratch_file = vim.fn.expand'~/.local/share/nvim/scratch.txt'
local scratch_file = vim.fn.expand'~/notes/inbox.org'

function _G.Scratchpad ()
  local current_file = vim.api.nvim_buf_get_name(0)
  local total_lines = vim.api.nvim_get_option'lines'
  local run = 'edit ' .. scratch_file
  local scratch_win = nil

  -- Close quickfix window since it breaks the scratch window.
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
    if saved_layout then
      vim.cmd(saved_layout)
      saved_layout = nil
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
    if saved_layout then
      vim.cmd(saved_layout)
      saved_layout = nil
    end
    if previous_window and vim.api.nvim_win_is_valid(previous_window) then
      vim.api.nvim_set_current_win(previous_window)
    end
    vim.cmd'echo ""'
    return
  end

  -- Open scratch window if it isn't already open.
  saved_layout = vim.fn.winrestcmd()
  previous_window = vim.api.nvim_get_current_win()
  if total_lines <= 26 then
    vim.cmd(run)
  else
    local win_height = math.ceil(total_lines * 0.5)
    vim.cmd'split'
    vim.cmd'wincmd K'
    vim.cmd('resize ' .. win_height)
    vim.cmd('edit ' .. scratch_file)
  end
end

module.fn = function ()
  UseKeymap('scratchpad', function () _G.Scratchpad() end)
end

return module

