local module = {
  name = 'fuzzy',
  desc = 'fuzzy finders',
  plugins = {
    {
      'ibhagwan/fzf-lua',
      -- dependencies = { 'echasnovski/mini.icons' },
      config = function ()
      end,
    },
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
    UseKeymap('fuzzy_files', function () fzf.files() end)
    UseKeymap('fuzzy_grep', function () fzf.grep_curbuf() end)
    UseKeymap('fuzzy_help', function () fzf.helptags() end)
    UseKeymap('fuzzy_buffers', function () fzf.buffers() end)
    UseKeymap('fuzzy_symbols', function () fzf.lsp_document_symbols() end)
    UseKeymap('fuzzy_workspace_symbols', function () fzf.lsp_workspace_symbols() end)
    UseKeymap('fuzzy_references', function () fzf.lsp_references() end)
    UseKeymap('fuzzy_diagnostics', function () fzf.diagnostics_document() end)
    UseKeymap('fuzzy_workspace_diagnostics', function () fzf.diagnostics_workspace() end)
    UseKeymap('fuzzy_code_actions', function () fzf.lsp_code_actions() end)
    UseKeymap('fuzzy_live_grep', function () fzf.live_grep() end)
    UseKeymap('fuzzy_command_history', function () fzf.command_history() end)
  end
}

return module

