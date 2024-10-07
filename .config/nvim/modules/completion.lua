local module = {
  name = 'completion',
  desc = 'setup autocompletion suggestions',
  dependencies = { 'intelligence' },
  plugins = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
  },
  fn = function ()
    local cmp = require'cmp'
    cmp.setup({
      snippet = {
        expand = function(args)
          -- vim.fn['vsnip#anonymous'](args.body)
          -- require('luasnip').lsp_expand(args.body)
          -- require('snippy').expand_snippet(args.body)
          -- vim.fn['UltiSnips#Anon'](args.body)
          vim.snippet.expand(args.body)
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        -- { name = 'luasnip' },
        -- { name = 'ultisnips' },
        -- { name = 'snippy' },
      }, {
        { name = 'buffer' },
      })
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false }
    })
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    require('lspconfig')['ts_ls'].setup { capabilities = capabilities }
    require('lspconfig')['lua_ls'].setup { capabilities = capabilities }
    require('lspconfig')['pyright'].setup { capabilities = capabilities }
    require('lspconfig')['html'].setup { capabilities = capabilities }
  end,
}

return module


