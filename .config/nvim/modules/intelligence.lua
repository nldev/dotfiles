local module = {
  name = 'intelligence',
  desc = 'configures LSPs and treesitter',
  plugins = {
    {
      'nvim-treesitter/nvim-treesitter',
      dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
      build = ':TSUpdate',
      event = { 'BufReadPre', 'BufNewFile' },
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
    local treesitter_configs = require'nvim-treesitter.configs'
    treesitter_configs.setup{
      auto_install = true,
      ensure_installed = {
        'bash',
        'css',
        'dockerfile',
        'fish',
        'gitignore',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = { enable = true },
      indent = { enable = false },
      fold = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['a='] = { query = '@assignment.outer', desc = 'Select outer assignment' },
            ['i='] = { query = '@assignment.inner', desc = 'Select inner assignment' },
            ['l='] = { query = '@assignment.lhs', desc = 'Select left assignment' },
            ['r='] = { query = '@assignment.rhs', desc = 'Select right assignment' },
            ['aa'] = { query = '@parameter.outer', desc = 'Select outer argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'Select inner argument' },
            ['ai'] = { query = '@conditional.outer', desc = 'Select outer conditional' },
            ['ii'] = { query = '@conditional.inner', desc = 'Select inner conditional' },
            ['al'] = { query = '@loop.outer', desc = 'Select outer loop' },
            ['il'] = { query = '@loop.inner', desc = 'Select inner loop' },
            ['af'] = { query = '@call.outer', desc = 'Select outer function call' },
            ['if'] = { query = '@call.inner', desc = 'Select inner function call' },
            ['am'] = { query = '@function.outer', desc = 'Select outer method' },
            ['im'] = { query = '@function.inner', desc = 'Select inner method' },
            ['ac'] = { query = '@class.outer', desc = 'Select outer class' },
            ['ic'] = { query = '@class.inner', desc = 'Select inner class' },
            ['ab'] = { query = '@block.outer', desc = 'Select outer block' },
            ['ib'] = { query = '@block.inner', desc = 'Select inner block' },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            -- FIXME: implement
            -- ['<leader>na'] = '@parameter.inner',
            -- ['<leader>nm'] = '@function.outer',
          },
          swap_previous = {
            -- FIXME: implement
            -- ['<leader>pa'] = '@parameter.inner',
            -- ['<leader>pm'] = '@function.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']b'] = { query = '@block.outer', desc = 'Next block' },
            [']f'] = { query = '@call.outer', desc = 'Next function call' },
            [']m'] = { query = '@function.outer', desc = 'Next method' },
            [']c'] = { query = '@class.outer', desc = 'Next class' },
            [']i'] = { query = '@conditional.outer', desc = 'Next conditional' },
            [']l'] = { query = '@loop.outer', desc = 'Next loop' },
            [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
            [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
          },
          goto_next_end = {
            [']B'] = { query = '@block.outer', desc = 'Next block end' },
            [']F'] = { query = '@call.outer', desc = 'Next function call end' },
            [']M'] = { query = '@function.outer', desc = 'Next method end' },
            [']C'] = { query = '@class.outer', desc = 'Next class end' },
            [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
            [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
          },
          goto_previous_start = {
            ['[b'] = { query = '@block.outer', desc = 'Prev block start' },
            ['[f'] = { query = '@call.outer', desc = 'Prev function call' },
            ['[m'] = { query = '@function.outer', desc = 'Prev method start' },
            ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
            ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
            ['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
          },
          goto_previous_end = {
            ['[B'] = { query = '@block.outer', desc = 'Prev block end' },
            ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
            ['[M'] = { query = '@function.outer', desc = 'Prev method end' },
            ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
            ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
            ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
          },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            -- FIXME: implement
            -- init_selection = '<c-space>',
            -- node_incremental = '<c-space>',
            -- scope_incremental = false,
            -- node_decremental = '<bs>',
          },
        },
        lsp_interop = {
          enable = true,
          border = 'none',
          floating_preview_opts = {},
          peek_definition_code = {
            ['<leader>df'] = { query = '@function.outer', desc = 'Preview outer [f]unction' },
            ['<leader>dc'] = { query = '@class.outer', desc = 'Preview outer [c]lass' },
          },
        },
      },
    }
    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
    local gs = require'gitsigns'
    local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
    vim.keymap.set({ 'n', 'x', 'o' }, ']h', next_hunk_repeat)
    vim.keymap.set({ 'n', 'x', 'o' }, '[h', prev_hunk_repeat)
    -- lsp
    local function on_attach (_, bufnr)
      if vim.b[bufnr].diagnostics_disabled or vim.g.diagnostics_disabled then
      	vim.diagnostic.disable(bufnr)
      end
    end
    require'mason'.setup()
    require'mason-lspconfig'.setup()
    require'lazydev'.setup()
    local servers = {
      lua_ls = {},
      html = {
        filetypes = {
          'html',
          'twig',
          'hbs',
        },
      },
      ts_ls = {},
      pyright = {},
      -- clangd = {},
    }
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require'cmp_nvim_lsp'.default_capabilities(capabilities)
    local mason_lspconfig = require'mason-lspconfig'
    mason_lspconfig.setup{ ensure_installed = vim.tbl_keys(servers) }
    mason_lspconfig.setup_handlers{
      function (server_name)
        require'lspconfig'[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        }
      end,
    }
    require'lspconfig'.ts_ls.setup{}
    UseKeymap('show_diagnostics', function () vim.diagnostic.open_float() end)
    UseKeymap('goto_definition', function () vim.lsp.buf.definition() end)
    UseKeymap('goto_type_definition', function () vim.lsp.buf.type_definition() end)
    UseKeymap('goto_implementation', function () vim.lsp.buf.implementation() end)
    UseKeymap('toggle_diagnostics', function () ToggleDiagnostics(true) end)
    UseKeymap('lsp_info', function () vim.lsp.buf.hover() end)
    UseKeymap('rename', function ()
      local current_name = vim.fn.expand'<cword>'
      vim.ui.input({ prompt = 'Rename ' .. current_name .. ': ', default = '', cancelreturn = nil }, function (new_name)
        if new_name and #new_name > 0 then
          vim.lsp.buf.rename(new_name)
          vim.cmd'echo ""'
        end
      end)
    end)
  end,
}

vim.g.diagnostics_active = true

_G.ToggleDiagnostics = function (is_global)
  local vars, bufnr, cmd
	if is_global then
		vars = vim.g
		bufnr = nil
	else
		vars = vim.b
		bufnr = 0
	end
	vars.diagnostics_disabled = not vars.diagnostics_disabled
	if vars.diagnostics_disabled then
		cmd = 'disable'
		vim.api.nvim_echo({ { 'diagnostics OFF' } }, false, {})
	else
		cmd = 'enable'
		vim.api.nvim_echo({ { 'diagnostics ON'} }, false, {})
	end
	vim.schedule(function () vim.diagnostic[cmd](bufnr) end)
end

return module

