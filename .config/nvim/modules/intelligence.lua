local module = {
  name = 'intelligence',
  desc = 'configures LSPs and treesitter',
  plugins = {
    {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      build = ':TSUpdate',
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'folke/lazydev.nvim', ft = 'lua' },
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
      },
    },
  },
  fn = function ()
    -- treesitter
    local treesitter_configs = require('nvim-treesitter.configs')
    treesitter_configs.setup({
      modules = {},
      ignore_install = {},
      auto_install = true,
      ensure_installed = ({ 'lua', 'vim', 'vimdoc', 'typescript', 'html', 'python' }),
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = false }, -- treesitter indenta doesn't work well at the moment
    })

    -- lsp
    local function on_attach (client, bufnr)
    end
    require('mason').setup()
    require('mason-lspconfig').setup()
    require('lazydev').setup()
    local servers = {
      lua_ls = {},
      html = { filetypes = { 'html', 'twig', 'hbs'} },
      ts_ls = {},
      pyright = {},
      -- clangd = {},
    }
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup { ensure_installed = vim.tbl_keys(servers) }
    mason_lspconfig.setup_handlers {
      function (server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        }
      end,
    }
    require('lspconfig').ts_ls.setup({})
    UseKeymap('show_diagnostic_window', function () vim.diagnostic.open_float() end)
    UseKeymap('goto_definition', function () vim.lsp.buf.definition() end)
    UseKeymap('goto_type_definition', function () vim.lsp.buf.type_definition() end)
    UseKeymap('goto_implementation', function () vim.lsp.buf.implementation() end)
    UseKeymap('rename', function ()
      local current_name = vim.fn.expand('<cword>')
      vim.ui.input({ prompt = 'Rename ' .. current_name .. ': ', default = '', cancelreturn = nil }, function (new_name)
        if new_name and #new_name > 0 then
          vim.lsp.buf.rename(new_name)
          vim.cmd('echo ""')
        end
      end)
    end)
  end,
}

return module

