local module = {
  name = 'notes',
  desc = 'Note-taking utilities',
  dependencies = { 'fuzzy' },
  plugins = {},
  fn = function ()
    local fzf = require('fzf-lua')
    UseKeymap('fuzzy_notes', function ()
      fzf.files({
        cwd = '~/notes',
        file_ignore_patterns = {
          '^.obsidian',
        },
      })
    end)
  end
}

return module

