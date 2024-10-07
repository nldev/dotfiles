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
    local fzf = require('fzf-lua')
    fzf.setup({
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
      },
      files = { silent = true },
    })
    UseKeymap('fuzzy_files', function () fzf.files() end)
    UseKeymap('fuzzy_grep', function () fzf.lgrep_curbuf() end)
    UseKeymap('fuzzy_help', function () fzf.helptags() end)
    UseKeymap('fuzzy_buffers', function () fzf.buffers() end)
    UseKeymap('fuzzy_symbols', function () fzf.lsp_document_symbols() end)
    UseKeymap('fuzzy_workspace_symbols', function () fzf.lsp_workspace_symbols() end)
    UseKeymap('fuzzy_references', function () fzf.lsp_references() end)
    UseKeymap('fuzzy_diagnostics', function () fzf.diagnostics_document() end)
    UseKeymap('fuzzy_workspace_diagnostics', function () fzf.diagnostics_workspace() end)
    UseKeymap('fuzzy_code_actions', function () fzf.lsp_code_actions() end)
    UseKeymap('fuzzy_live_grep', function () fzf.live_grep() end)
    -- FIXME: clean up code * use fzf hook rather than autocmd
    -- vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
    --   callback = function ()
    --     local min_width = 80
    --     if vim.fn.winwidth(0) < min_width then
    --       fzf.setup {
    --         winopts = {
    --           preview = {
    --             hidden = 'hidden',
    --           }
    --         }
    --       }
    --     else
    --       fzf.setup {
    --         winopts = {
    --           preview = {
    --             hidden = 'nohidden',
    --           }
    --         }
    --       }
    --     end
    --   end
    -- })
  end
}

return module

