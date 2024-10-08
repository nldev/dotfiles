DefPrefix({
  open = { '<leader>o', desc = '[O]pen' },
  open_vim = { '<leader>ov', desc = 'Open n[v]im config' },
  finder = { '<leader>f', desc = '[F]inders' },
  notes = { '<leader>n', desc = '[N]otes' },
  snipe = { '<leader>s', desc = 'Bookmark[s]' },
})

DefKeymap({
  clear = { '<c-c>', mode = { 'n' }, desc = '[C]lear session' },
  write_file = { '<c-s>', mode = { 'n', 'x', 'o', 'i' }, desc = '[W]rite' },
  jump = { 's', mode = { 'n', 'x', 'o' }, desc = 'Jump' },
  jump_treesitter = { 'S', mode = { 'n', 'x', 'o' }, desc = 'Treesitter jump' },
  open_file_browser = { 'o', prefix = 'open', mode = { 'n' }, desc = 'Explore current directory' },
  open_config_vim_autocmds = { 'a', prefix = 'open_vim', mode = { 'n' }, desc = 'Open nvim/[a]utocmds.lua' },
  open_config_vim_context = { 'C', prefix = 'open_vim', mode = { 'n' }, desc = 'Explore ~/.[c]ontext/nvim' },
  open_config_vim_fuzzy_context = { 'c', prefix = 'open_vim', mode = { 'n' }, desc = 'Fuzzy ~/.[c]ontext/nvim' },
  open_config_vim_init = { 'i', prefix = 'open_vim', mode = { 'n' }, desc = 'Open nvim/[i]nit.lua' },
  open_config_vim_keymaps = { 'k', prefix = 'open_vim', mode = { 'n' }, desc = 'Open nvim/[k]eymaps.lua' },
  open_config_vim_modules = { 'M', prefix = 'open_vim', mode = { 'n' }, desc = 'Explore nvim/[m]odules' },
  open_config_vim_fuzzy_modules = { 'm', prefix = 'open_vim', mode = { 'n' }, desc = 'Fuzzy nvim/[m]odules' },
  open_config_vim_api = { '`', prefix = 'open_vim', mode = { 'n' }, desc = 'Open nvim/api.lua' },
  fuzzy_files = { 'f', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy [f]iles' },
  fuzzy_symbols = { 's', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy [s]ymbols' },
  fuzzy_workspace_symbols = { 'S', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy project symbols' },
  fuzzy_references = { 'r', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy [r]eferences' },
  fuzzy_diagnostics = { 'x', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy diagnostics' },
  fuzzy_workspace_diagnostics = { 'X', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy project diagnostics' },
  fuzzy_code_actions = { 'a', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy code [a]ctions' },
  fuzzy_live_grep = { 'g', prefix = 'finder', mode = { 'n' }, desc = 'Fuzzy project [g]rep' },
  fuzzy_grep = { '<leader>/', mode = { 'n' }, desc = 'Fuzzy grep' },
  fuzzy_help = { '<leader>?', mode = { 'n' }, desc = 'Fuzzy help' },
  fuzzy_buffers = { '<leader><space>', mode = { 'n' }, desc = 'Fuzzy buffers' },
  fuzzy_notes = { 'n', prefix = 'notes', mode = { 'n' }, desc = 'Fuzzy [n]otes' },
  toggle_auto_comments = { '<leader>A', mode = { 'n' }, desc = 'Toggle auto comments' },
  smart_comma = { '<f13>', mode = { 'i' }, desc = 'Context-aware comma insertion' },
  goto_definition = { 'd', prefix = 'finder', mode = { 'n' }, desc = 'Goto [d]efinition' },
  goto_type_definition = { 't', prefix = 'finder', mode = { 'n' }, desc = 'Goto [t]ype definition' },
  goto_implementation = { 'i', prefix = 'finder', mode = { 'n' }, desc = 'Goto [i]mplementation' },
  rename = { '<leader>r', mode = { 'n' }, desc = 'Rename symbol' },
  show_diagnostics = { '<leader>d', mode = { 'n' }, desc = 'Show [d]iagnostics' },
  code_actions = { '<leader>a', mode = { 'n' }, desc = 'Show code [a]ctions' },
  code_actions_range = { '<leader>a', mode = { 'v' }, desc = 'Show code [a]ctions' },
  snipe_add = { 'a', prefix = 'snipe', mode = { 'n'}, desc = '[A]dd to bookmark list' },
  snipe_add_line = { 'l', prefix = 'snipe', mode = { 'n'}, desc = 'Add to bookmark list with [l]ine:col' },
  snipe_select = { 's', prefix = 'snipe', mode = { 'n'}, desc = '[S]how bookmark list' },
  snipe_delete = { 'd', prefix = 'snipe', mode = { 'n'}, desc = '[D]elete from bookmark list' },
  snipe_clear = { 'c', prefix = 'snipe', mode = { 'n'}, desc = '[C]lear bookmark list' },
})

