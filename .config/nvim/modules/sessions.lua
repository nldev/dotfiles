local module = {
  name = 'sessions',
  desc = 'session management',
  plugins = {
    'folke/persistence.nvim',
  },
  fn = function ()
    local persistence = require('persistence')
    persistence.setup()
    persistence.load({ last = true })
  end
}

return module

