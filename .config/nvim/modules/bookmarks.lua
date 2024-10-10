local module = {
  name = 'bookmarks',
  desc = 'file navigation',
  plugins = {
    'leath-dub/snipe.nvim',
  },
}

local function get_git_root ()
  local git_root = vim.fn.system("git rev-parse --show-toplevel")
  if vim.v.shell_error == 0 then
    return vim.fn.fnamemodify(git_root, ':p'):gsub('\n', '')
  else
    return nil
  end
end

local function get_project_list_file ()
  local git_root = get_git_root()
  local cache_dir = vim.fn.stdpath('data') .. '/nvim_project_lists'
  vim.fn.mkdir(cache_dir, 'p')

  if git_root then
    return cache_dir .. '/' .. vim.fn.fnamemodify(git_root, ':t') .. '_list.txt'
  end
  return cache_dir .. '/global_list.txt'
end

local function format_file_path (filepath, git_root)
  if git_root and filepath:find(git_root, 1, true) then
    return vim.fn.fnamemodify(filepath, ':.')
  else
    return vim.fn.fnamemodify(filepath, ':p')
  end
end

local function get_comment ()
  local comment = vim.fn.input('Add a comment (optional): ')
  return comment
end

local function serialize_entry (meta)
  local label = meta.comment ~= '' and (meta.comment .. ' :: ') or ''
  local display_path = meta.path
  if meta.linecol then
    return string.format('%s%s:%s', label, display_path, meta.linecol)
  else
    return label .. display_path
  end
end

local function deserialize_entry (line)
  local comment, path_part = line:match('^(.*) :: (.*)$')
  if not comment then
    path_part = line
  end
  local path, linecol = path_part:match('^(.*):([%d]+:%d+)$')
  if not path then
    path = path_part
  end
  if path:sub(-1) == "*" then
    path = path:sub(1, -2)
  end
  return {
    path = path,
    linecol = linecol,
    comment = comment or "",
  }
end

local function add_to_list (meta)
  local cache_file = get_project_list_file()
  local lines = {}
  if vim.fn.filereadable(cache_file) == 1 then
    lines = vim.fn.readfile(cache_file)
  end
  local entry = serialize_entry(meta)
  if not vim.tbl_contains(lines, entry) then
    table.insert(lines, entry)
    vim.fn.writefile(lines, cache_file)
    vim.notify('Added to snipe list: ' .. meta.path)
  else
    vim.notify('Entry is already in snipe list')
  end
end

local function add_with_line_column ()
  local current_buffer = vim.api.nvim_buf_get_name(0)
  local git_root = get_git_root()
  local line = vim.fn.line('.')
  local column = vim.fn.col('.')
  local formatted_path = format_file_path(current_buffer, git_root)
  local meta = {
    path = formatted_path,
    linecol = string.format('%d:%d', line, column),
    comment = get_comment(),
  }
  add_to_list(meta)
end

local function add_without_line_column ()
  local current_buffer = vim.api.nvim_buf_get_name(0)
  local git_root = get_git_root()
  local formatted_path = format_file_path(current_buffer, git_root)
  local meta = {
    path = formatted_path,
    linecol = nil,
    comment = get_comment()
  }
  add_to_list(meta)
end

local function delete_from_list ()
  local cache_file = get_project_list_file()
  if not cache_file then
    vim.notify('Error: No snipe list found.', vim.log.levels.ERROR)
    return
  end
  local lines = {}
  if vim.fn.filereadable(cache_file) == 1 then
    lines = vim.fn.readfile(cache_file)
  else
    vim.notify('No entries found.', vim.log.levels.INFO)
    return
  end
  require'snipe'.create_menu_toggler(function ()
    local items_display = vim.tbl_map(function (line)
      return line
    end, lines)
    return lines, items_display
  end, function(meta, idx)
    if meta and lines[idx] then
      table.remove(lines, idx)  -- Remove the selected entry from the list
      vim.fn.writefile(lines, cache_file)
      vim.notify('Entry deleted.')
    else
      vim.notify('Error: Invalid selection.', vim.log.levels.ERROR)
    end
  end)()
end

local function clear_list()
  local cache_file = get_project_list_file()
  if not cache_file then
    vim.notify('Error: snipe list found.', vim.log.levels.ERROR)
    return
  end
  local confirm = vim.fn.input('Are you sure you want to clear the list? (Y/N): ')
  if confirm:lower() == 'y' then
    vim.fn.writefile({}, cache_file)
    vim.notify('Cleared snipe list.')
  else
    vim.notify('List clearing canceled.')
  end
end

local function snipe_list_producer ()
  local cache_file = get_project_list_file()
  local lines = {}
  if vim.fn.filereadable(cache_file) == 1 then
    lines = vim.fn.readfile(cache_file)
  end
  local items = {}
  local items_display = vim.tbl_map(function (line)
    local meta = deserialize_entry(line) -- Deserialize the line back to metadata
    table.insert(items, meta)
    return serialize_entry(meta)
  end, lines)
  return items, items_display
end

local function snipe_menu_toggler ()
  return require'snipe'.create_menu_toggler(snipe_list_producer, function (meta, _)
    vim.cmd.edit(meta.path)
    if meta.linecol then
      local line, col = meta.linecol:match('(%d+):(%d+)')
      if line and col then
        vim.api.nvim_win_set_cursor(0, { tonumber(line), tonumber(col) - 1 })
      end
    end
  end)
end


module.fn = function ()
  require'snipe'.setup()
  UseKeymap('snipe_add', add_without_line_column)
  UseKeymap('snipe_add_line', add_with_line_column)
  UseKeymap('snipe_select', snipe_menu_toggler())
  UseKeymap('snipe_delete', delete_from_list)
  UseKeymap('snipe_clear', clear_list)
end

return module

