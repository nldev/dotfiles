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
    UseKeymap('notes_explore', function () require'mini.files'.open(dir, false) end)
    UseKeymap('notes_grep', function () require'telescope.builtin'.live_grep{ cwd = '~/notes' } end)
    UseKeymap('notes_search', function () Notes.topics() end)
  end
}

return module

