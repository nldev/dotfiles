local module = {
  name = 'notes',
  desc = 'Note-taking utilities',
  dependencies = { 'fuzzy', 'files' },
  plugins = {
    {
      'nvim-orgmode/orgmode',
      event = 'VeryLazy',
      ft = { 'org' },
    },
    {
      'chipsenkbeil/org-roam.nvim',
      tag = '0.1.0',
      dependencies = {
        {
          'nvim-orgmode/orgmode',
          tag = '0.3.4',
        },
      },
    },
    -- {
    --   'epwalsh/obsidian.nvim',
    --   version = '*',
    --   event = 'VeryLazy',
    --   dependencies = {
    --     'nvim-lua/plenary.nvim',
    --     'hrsh7th/nvim-cmp',
    --   },
    --   opts = {
    --     templates = {
    --       folder = '99 - Meta/Templates',
    --       date_format = '%Y-%m-%d',
    --       time_format = '%H:%M',
    --       substitutions = {},
    --     },
    --     daily_notes = {
    --       folder = '02 - Journal/Daily',
    --       date_format = '%Y-%m-%d',
    --       default_tags = {},
    --       template = '01 - Daily Note',
    --     },
    --     completion = {
    --       nvim_cmp = true,
    --       min_chars = 2,
    --     },
    --     picker = {
    --       name = 'telescope.nvim',
    --     },
    --     workspaces = {
    --       {
    --         name = 'me',
    --         path = '~/notes',
    --       },
    --     },
    --     mappings = {},
    --     use_advanced_uri = false,
    --     note_frontmatter_func = function (note)
    --       -- if note.title then
    --       --   note:add_alias(note.title)
    --       -- end
    --       local out = { id = note.id, tags = note.tags, date = os.date('%Y-%m-%d') }
    --       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
    --         for k, v in pairs(note.metadata) do
    --           out[k] = v
    --         end
    --       end
    --       return out
    --     end,
    --     note_id_func = function (title)
    --       local date = tostring(os.date('%Y%m%d%H%M%S'))
    --       if title then
    --         return title .. '-' .. date
    --       end
    --       return '' .. date
    --     end,
    --   },
    -- },
  },
  fn = function ()
    local org = require'orgmode'
    org.setup{
      org_agenda_files = '~/notes/**/*',
      org_default_notes_file = '~/notes/Inbox.org',
      mappings = { disable_all = true },
    }
    local roam = require'org-roam'
    roam.setup{
      directory = '~/notes',
      extensions = {
        dailies = {
          bindings = false,
        },
      },
      bindings = {
        add_alias                = '',
        add_origin               = '',
        capture                  = '',
        complete_at_point        = '',
        find_node                = '',
        goto_next_node           = '',
        goto_prev_node           = '',
        insert_node              = '',
        insert_node_immediate    = '',
        quickfix_backlinks       = '',
        remove_alias             = '',
        remove_origin            = '',
        toggle_roam_buffer       = '',
        toggle_roam_buffer_fixed = '',
      },
    }
    UseKeymap('note_agenda', function () org.action'agenda.prompt' end)
    UseKeymap('note_todo', function () org.action'capture.prompt' end)
    UseKeymap('note_capture', function () roam.api.capture_node() end)
    UseKeymap('note_insert', function () roam.api.complete_node() end)
    UseKeymap('note_normal_insert', function () roam.api.insert_node() end)
    UseKeymap('note_fuzzy', function () require'telescope.builtin'.find_files{ cwd = '~/notes' } end)
    UseKeymap('note_inbox', function () vim.cmd'e ~/notes/Inbox.org' end)
    UseKeymap('note_schedule', function () org.action'org_mappings.org_schedule' end)
    UseKeymap('note_promote', function () org.action'org_mappings.do_promote' end)
    UseKeymap('note_demote', function () org.action'org_mappings.do_demote' end)
    -- UseKeymap('note_refile', function () org.action'capture.refile' end)
    UseKeymap('note_todo_change', function ()
      if vim.bo.filetype == 'orgagenda' then
        org.action'agenda.change_todo_state'
        return
      end
      org.action'org_mappings.todo_next_state'
    end)
    UseKeymap('note_explore', function ()
      require'mini.files'.open('~/notes', false)
    end)
  end
}

return module

