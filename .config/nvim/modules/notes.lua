local module = {
  name = 'notes',
  desc = 'Note-taking utilities',
  dependencies = { 'fuzzy', 'files' },
  plugins = {
    {
      'epwalsh/obsidian.nvim',
      version = '*',
      event = 'VeryLazy',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'hrsh7th/nvim-cmp',
        'ibhagwan/fzf-lua',
      },
      opts = {
        templates = {
          folder = '99 - Meta/Templates',
          date_format = '%Y-%m-%d',
          time_format = '%H:%M',
          substitutions = {},
        },
        daily_notes = {
          folder = '02 - Journal/Daily',
          date_format = '%Y-%m-%d',
          default_tags = {},
          template = '01 - Daily Note',
        },
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },
        picker = {
          name = 'fzf-lua',
        },
        workspaces = {
          {
            name = 'me',
            path = '~/notes',
          },
        },
        mappings = {},
        use_advanced_uri = false,
        note_frontmatter_func = function (note)
          -- if note.title then
          --   note:add_alias(note.title)
          -- end
          local out = { id = note.id, tags = note.tags, date = os.date('%Y-%m-%d') }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,
        note_id_func = function (title)
          local date = tostring(os.date('%Y%m%d%H%M%S'))
          if title then
            return title .. '-' .. date
          end
          return '' .. date
        end,
      },
    },
  },
  fn = function ()
    -- create inbox note
    UseKeymap('note_inbox', function ()
      vim.cmd('ObsidianNew 96 - Inbox/' .. tostring(os.date('%Y%m%d%H%M%S')) .. '.md')
    end)

    -- create permanent note
    UseKeymap('note_create', function ()
      local name = vim.fn.input('Note title: ')
      vim.cmd('ObsidianNew 01 - Notes/' .. name .. '.md')
    end)

    -- create reference note
    UseKeymap('note_reference', function ()
      local name = vim.fn.input('Reference note title: ')
      vim.cmd('ObsidianNew 04 - References/' .. name .. '.md')
    end)

    -- create directory note
    UseKeymap('note_directory', function ()
      local name = vim.fn.input('Directory note title: ')
      vim.cmd('ObsidianNew 00 - Directories/' .. name .. '.md')
    end)

    -- explore notes
    UseKeymap('note_explore', function ()
      require'mini.files'.open('~/notes', false)
    end)

    -- fuzzy notes
    UseKeymap('note_fuzzy', function ()
      vim.cmd('ObsidianQuickSwitch')
    end)
  end
}

return module

