local module = {
  name = 'notes',
  desc = 'Note-taking utilities',
  dependencies = { 'search', 'files' },
  plugins = {
    {
      'nvim-orgmode/orgmode',
      event = 'VeryLazy',
      ft = { 'org' },
    },
    -- {
    --   'nvim-orgmode/telescope-orgmode.nvim',
    --   event = 'VeryLazy',
    --   ft = { 'org' },
    -- },
    -- {
    --   'chipsenkbeil/org-roam.nvim',
    --   tag = '0.1.0',
    --   dependencies = {
    --     {
    --       'nvim-orgmode/orgmode',
    --       tag = '0.3.4',
    --     },
    --   },
    -- },
    -- {
    --   'lukas-reineke/headlines.nvim',
    --   dependencies = 'nvim-treesitter/nvim-treesitter',
    --   config = true,
    -- },
    'meanderingprogrammer/render-markdown.nvim',
  },
  fn = function ()
    local org = require'orgmode'
    org.setup{
      org_agenda_files = '~/notes/**/*',
      org_default_notes_file = '~/notes/inbox.org',
      mappings = { disable_all = true },
    }
    -- local roam = require'org-roam'
    -- roam.setup{
    --   directory = '~/notes',
    --   extensions = {
    --     dailies = {
    --       bindings = false,
    --     },
    --   },
    --   bindings = {
    --     add_alias                = '',
    --     add_origin               = '',
    --     capture                  = '',
    --     complete_at_point        = '',
    --     find_node                = '',
    --     goto_next_node           = '',
    --     goto_prev_node           = '',
    --     insert_node              = '',
    --     insert_node_immediate    = '',
    --     quickfix_backlinks       = '',
    --     remove_alias             = '',
    --     remove_origin            = '',
    --     toggle_roam_buffer       = '',
    --     toggle_roam_buffer_fixed = '',
    --   },
    -- }
    UseKeymap('note_agenda', function () org.action'agenda.prompt' end)
    UseKeymap('note_todo', function () org.action'capture.prompt' end)
    -- UseKeymap('note_capture', function () roam.api.capture_node() end)
    -- -- UseKeymap('note_insert', function () roam.api.complete_node() end)
    -- UseKeymap('note_normal_insert', function () roam.api.insert_node() end)
    UseKeymap('note_fuzzy', function () require'telescope.builtin'.find_files{ cwd = '~/notes' } end)
    -- -- UseKeymap('note_fuzzy', function () roam.api.find_node() end)
    -- UseKeymap('note_inbox', function () vim.cmd'e ~/notes/inbox.org' end)
    -- UseKeymap('note_schedule', function () org.action'org_mappings.org_schedule' end)
    -- UseKeymap('note_promote', function () org.action'org_mappings.do_promote' end)
    -- UseKeymap('note_demote', function () org.action'org_mappings.do_demote' end)
    -- -- UseKeymap('note_refile', function () org.action'capture.refile' end)
    -- UseKeymap('note_todo_change', function ()
    --   if vim.bo.filetype == 'orgagenda' then
    --     org.action'agenda.change_todo_state'
    --     return
    --   end
    --   org.action'org_mappings.todo_next_state'
    -- end)
    UseKeymap('note_explore', function ()
      require'mini.files'.open('~/notes', false)
    end)
    -- UseKeymap('note_headings', function ()
    --   require'telescope'.extensions.orgmode.search_headings()
    -- end)
    -- UseKeymap('note_refile', function ()
    --   require'telescope'.extensions.orgmode.refile_heading()
    -- end)
    -- UseKeymap('note_insert', function ()
    --   require'telescope'.extensions.orgmode.insert_link()
    -- end)
  end
}

return module

