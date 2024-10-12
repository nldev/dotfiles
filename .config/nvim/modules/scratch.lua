local module = {
  name = 'scratch',
  desc = 'scratch window utility',
  plugins = {},
}

local previous_window = nil
local scratch_file = vim.fn.expand('~/.local/share/nvim/scratch.txt')

function Scratch ()
  local current_file = vim.api.nvim_buf_get_name(0)
  local total_lines = vim.api.nvim_get_option('lines')
  local run = 'edit ' .. scratch_file
  local scratch_win = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == scratch_file then
      scratch_win = win
      break
    end
  end
  if scratch_win and scratch_win ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(scratch_win)
    vim.cmd('write')
    vim.cmd('bdelete')
    if previous_window then
      vim.api.nvim_set_current_win(previous_window)
    end
    return
  end
  if current_file == scratch_file then
    vim.cmd('write')
    local win_count = #vim.api.nvim_tabpage_list_wins(0)
    if win_count > 1 then
      vim.cmd('close')
    else
      vim.cmd('bdelete')
    end
    if previous_window and vim.api.nvim_win_is_valid(previous_window) then
      vim.api.nvim_set_current_win(previous_window)
    end
    vim.cmd('echo ""')
    return
  end
  previous_window = vim.api.nvim_get_current_win()
  if total_lines <= 26 then
    vim.cmd(run)
  else
    local win_height = math.ceil(total_lines * 0.5)
    vim.cmd('split')
    vim.cmd('wincmd K')
    vim.cmd('resize ' .. win_height)
    vim.cmd('edit ' .. scratch_file)
  end
end

module.fn = function ()
  UseKeymap('scratch', function () Scratch() end)
end

return module

