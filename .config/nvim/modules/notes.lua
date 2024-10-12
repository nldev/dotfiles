local module = {
  name = 'notes',
  desc = 'Note-taking utilities',
  dependencies = { 'fuzzy' },
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
        use_advanced_uri = false,
        note_frontmatter_func = function (note)
          if note.title then
            note:add_alias(note.title)
          end
          local out = { tags = note.tags, date = os.date('%Y-%m-%d') }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,
        note_id_func = function (title)
          return title or tostring(os.date('%Y%m%d%H%M%S'))
        end,
      },
    },
  },
  fn = function ()
    -- create inbox note
    vim.keymap.set('n', '<leader>na', function ()
      vim.cmd('ObsidianNew 96 - Inbox/' .. tostring(os.date('%Y%m%d%H%M%S')) .. '.md')
    end, { noremap = true, silent = false })

    -- create permanent note
    vim.keymap.set('n', '<leader>nc', function ()
      local name = vim.fn.input('Note title: ')
      vim.cmd('ObsidianNew 01 - Notes/' .. name .. '.md')
    end, { noremap = true, silent = false })

    -- create reference note
    vim.keymap.set('n', '<leader>nr', function ()
      local name = vim.fn.input('Reference note title: ')
      vim.cmd('ObsidianNew 04 - References/' .. name .. '.md')
    end, { noremap = true, silent = false })

    -- create blog post
    vim.keymap.set('n', '<leader>nb', function ()
      local name = vim.fn.input('Blog post title: ')
      vim.cmd('ObsidianNew 05 - Blogs/' .. name .. '.md')
    end, { noremap = true, silent = false })

    -- create directory note
    vim.keymap.set('n', '<leader>ni', function ()
      local name = vim.fn.input('Directory note title: ')
      vim.cmd('ObsidianNew 00 - Directories/' .. name .. '.md')
    end, { noremap = true, silent = false })

    -- fuzzy notes
    vim.keymap.set('n', '<leader>nn', function () vim.cmd('ObsidianQuickSwitch') end, { noremap = true, silent = false })
  end
}

return module

