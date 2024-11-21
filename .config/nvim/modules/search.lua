local module = {
  name = 'search',
  desc = 'fuzzy finders',
  plugins = {
    {
      'ibhagwan/fzf-lua',
      config = function () end,
    },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
      'prochri/telescope-all-recent.nvim',
      dependencies = {
        'nvim-telescope/telescope.nvim',
        'kkharji/sqlite.lua',
        -- 'stevearc/dressing.nvim',
      },
      opts = {},
    }
  },
  fn = function ()
    local fzf = require'fzf-lua'
    fzf.setup{
      -- 'max-perf',
      winopts = {
        height = 0.5,
        row = 1.0,
        width = 1.0,
        col = 0.5,
        preview = {
          layout = 'horizontal',
          width = 0.5,
        },
        backdrop = 100,
      },
      files = { silent = true },
    }
    require'telescope'.setup{
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          height = math.floor(vim.o.lines / 2),
          width = vim.o.columns,
          anchor = 'S',
          anchor_padding = 0,
          prompt_position = 'bottom',
          preview_width= 0.5,
          preview_cutoff = 60,
        },
      },
    }
    -- require'telescope-all-recent'.setup{
    --   default = { sorting = 'frecency' },
    -- }
    local telescope = require'telescope.builtin'
    UseKeymap('search_files', function () telescope.find_files() end)
    UseKeymap('search_live_grep', function () telescope.live_grep() end)
    UseKeymap('search_help', function () telescope.help_tags() end)
    UseKeymap('search_buffers', function () telescope.buffers() end)
    UseKeymap('search_symbols', function () telescope.lsp_document_symbols() end)
    UseKeymap('search_references', function () telescope.lsp_references() end)
    UseKeymap('search_diagnostics', function () telescope.diagnostics() end)
    UseKeymap('search_command_history', function () telescope.command_history() end)
    UseKeymap('search_grep', function ()
      if vim.api.nvim_buf_line_count(0) > 5000 then
        fzf.grep_curbuf()
      else
        telescope.current_buffer_fuzzy_find()
      end
    end)
    UseKeymap('search_workspace_diagnostics', function () fzf.diagnostics_workspace() end)
    UseKeymap('search_code_actions', function () fzf.lsp_code_actions() end)
  end
}

return module

