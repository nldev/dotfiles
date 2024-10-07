local config = vim.fn.stdpath('config')

-- run module prerequisites
dofile(config .. '/api.lua')
dofile(config .. '/autocmds.lua')
dofile(config .. '/keymaps.lua')

-- load normal modules
Load(config .. '/modules')

-- load contextual modules
Load('~/.context/nvim')

-- initialize modules
Init()

