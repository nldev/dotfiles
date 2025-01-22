local module = {
  name = 'notes',
  desc = 'Note-taking utilities',
  dependencies = { 'search', 'files' },
  -- plugins = {
  --   'meanderingprogrammer/render-markdown.nvim',
  -- },
  fn = function ()
    local dir = vim.fn.expand'~/notes'
    require'notes'.setup{ debug = true }
    UseKeymap('notes_inbox', function () Notes.inbox() end)
    UseKeymap('notes_toc', function () Notes.toc() end)
    UseKeymap('notes_toggle', function () Notes.toggle() end)
    UseKeymap('notes_add', function () Notes.add() end)
    UseKeymap('notes_bookmark_1', function () Notes.bookmark(1) end)
    UseKeymap('notes_bookmark_2', function () Notes.bookmark(2) end)
    UseKeymap('notes_bookmark_3', function () Notes.bookmark(3) end)
    UseKeymap('notes_bookmark_4', function () Notes.bookmark(4) end)
    UseKeymap('notes_bookmark_5', function () Notes.bookmark(5) end)
    UseKeymap('notes_delete_bookmark_1', function () Notes.delete_bookmark(1) end)
    UseKeymap('notes_delete_bookmark_2', function () Notes.delete_bookmark(2) end)
    UseKeymap('notes_delete_bookmark_3', function () Notes.delete_bookmark(3) end)
    UseKeymap('notes_delete_bookmark_4', function () Notes.delete_bookmark(4) end)
    UseKeymap('notes_delete_bookmark_5', function () Notes.delete_bookmark(5) end)
    UseKeymap('notes_goto_bookmark_1', function () Notes.goto_bookmark(1) end)
    UseKeymap('notes_goto_bookmark_2', function () Notes.goto_bookmark(2) end)
    UseKeymap('notes_goto_bookmark_3', function () Notes.goto_bookmark(3) end)
    UseKeymap('notes_goto_bookmark_4', function () Notes.goto_bookmark(4) end)
    UseKeymap('notes_goto_bookmark_5', function () Notes.goto_bookmark(5) end)
    UseKeymap('notes_undo', function () Notes.undo() end)
    UseKeymap('notes_bookmarks', function () Notes.bookmarks() end)
    UseKeymap('notes_explore', function ()
      require'mini.files'.open(dir, false)
    end)
    UseKeymap('notes_grep', function () require'telescope.builtin'.live_grep{ cwd = '~/notes' } end)
    -- FIXME: move topic search to plugin
    -- FIXME: display bookmark / last note flags before heading
    -- FIXME: sort by last accessed unless search input exists (cache this on disk)
    local finders = require'telescope.finders'
    local pickers = require'telescope.pickers'
    local conf = require'telescope.config'.values
    local cache = {}
    local function get_headings ()
      local files = vim.fn.systemlist'rg --files --glob "*.md" ~/notes'
      local entries = {}
      for _, file in ipairs(files) do
        if cache[file] then
          table.insert(entries, { file = file, heading = cache[file] })
        elseif file ~= vim.fn.expand'~/notes/inbox.md' and file ~= vim.fn.expand'~/notes/toc.md' then
          local heading = nil
          for line in io.lines(file) do
            heading = line:match'^#%s(.+)'
            if heading then
              table.insert(entries, { file = file, heading = heading })
              table.insert(cache, heading)
              break
            end
          end
        end
      end
      return entries
    end
    local function find_markdown_files (opts)
      opts = opts or {}
      local entries = get_headings()
      pickers.new(opts, {
        prompt_title = 'Find Topic',
        finder = finders.new_table({
          results = entries,
          entry_maker = function(entry)
            return {
              value = entry.file,
              display = string.format('%s', entry.heading),
              ordinal = entry.heading,
              filename = entry.file
            }
          end
        }),
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer(opts),
      }):find()
    end
    UseKeymap('notes_search', function () find_markdown_files() end)
  end
}

return module

