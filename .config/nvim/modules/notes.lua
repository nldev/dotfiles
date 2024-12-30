local module = {
  name = 'notes',
  desc = 'Note-taking utilities',
  dependencies = { 'search', 'files' },
  plugins = {
    'meanderingprogrammer/render-markdown.nvim',
  },
  fn = function ()
    require'notes'.setup{ debug = true }
    UseKeymap('note_explore', function ()
      require'mini.files'.open('~/notes', false)
    end)
  end
}

return module

