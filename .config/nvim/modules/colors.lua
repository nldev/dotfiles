local module = {
  name = 'colors',
  desc = 'defines colorscheme and highlighting',
  plugins = {
    -- turn off all default colors
    'pbrisbin/vim-colors-off',
    -- highlighting
    'brenoprata10/nvim-highlight-colors',
  },
  fn = function ()
    vim.cmd('color off')
    vim.cmd('syntax enable')
    vim.cmd('hi StatusLine      guibg=#1b1d1e')
    vim.cmd('hi Normal          guibg=NONE    guifg=#cccccc')
    vim.cmd('hi String                        guifg=#ba9cf3')
    vim.cmd('hi Comment                       guifg=#828a9a')
    vim.cmd('hi Boolean                       guifg=#ba9cf3')
    vim.cmd('hi Number                        guifg=#ba9cf3')
    vim.cmd('hi @lsp.type.enum                guifg=#ffffff')
    vim.cmd('hi @lsp.type.variable            guifg=#ffffff')
    vim.cmd('hi @lsp.type.class               guifg=#ffffff')
    vim.cmd('hi @lsp.type.function            guifg=#ffffff')
    vim.cmd('hi @lsp.type.parameter           guifg=#f69c5e')
    vim.cmd('hi @lsp.type.type                guifg=#7ad5f1')
    vim.cmd('hi @lsp.type.typeParameter       guifg=#a5e179')
    vim.cmd('hi Keyword                       guifg=#ff6d7e')
    vim.cmd('hi FlashCurrent    guibg=#ff69b4 guifg=#000000')
    vim.cmd('hi FlashMatch      guibg=#aabbff guifg=#000000')
    vim.cmd('hi FlashLabel      guibg=#aaff55 guifg=#000000')
    vim.cmd('hi IncSearch       guibg=#caff00 guifg=#000000')
    vim.cmd('hi Search          guibg=#66d9ef guifg=#000000')
    vim.cmd('hi GitSignsAdd                   guifg=#a5e179')
    vim.cmd('hi GitSignsChange                guifg=#7ad5f1')
    vim.cmd('hi GitSignsDelete                guifg=#ff6d7e')
    vim.cmd('hi DiagnosticError               guifg=#ff6d7e')
    vim.cmd('hi DiagnosticWarn                guifg=#f69c5e')
    vim.cmd('hi DiagnosticInfo                guifg=#7ad5f1')
    vim.cmd('hi DiagnosticHint                guifg=#ba9cf3')
    require('nvim-highlight-colors').setup({})
  end
}

return module

