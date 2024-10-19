local module = {
  name = 'colors',
  desc = 'defines colorscheme and highlighting',
  plugins = {
    'pbrisbin/vim-colors-off',
    'brenoprata10/nvim-highlight-colors',
  },
  fn = function ()
    -- Turn on syntax highlighting.
    vim.cmd'syntax on'

    -- Use 'off' colorscheme.
    vim.cmd'color off'

    -- Enable color code highlighting.
    require'nvim-highlight-colors'.setup()

    -- Apply colors to highlight groups.
    vim.cmd'hi StatusLine      guibg=#1b1d1e'
    vim.cmd'hi Normal          guibg=NONE    guifg=#cccccc'
    vim.cmd'hi String                        guifg=#b7bdf8'
    vim.cmd'hi Comment                       guifg=#828a9a'
    vim.cmd'hi Boolean                       guifg=#c6a0f6'
    vim.cmd'hi Number                        guifg=#8aadf4'
    vim.cmd'hi @lsp.type.enum                guifg=#ffffff'
    vim.cmd'hi @lsp.type.variable            guifg=#ffffff'
    vim.cmd'hi @lsp.type.class               guifg=#ffffff'
    vim.cmd'hi @lsp.type.function            guifg=#ffffff'
    vim.cmd'hi @lsp.type.parameter           guifg=#f5a97f'
    vim.cmd'hi @lsp.type.type                guifg=#7dc4e4'
    vim.cmd'hi @lsp.type.typeParameter       guifg=#a6da95'
    vim.cmd'hi Keyword                       guifg=#ed8796'
    vim.cmd'hi FlashCurrent    guibg=#ff69b4 guifg=#000000'
    vim.cmd'hi FlashMatch      guibg=#aabbff guifg=#000000'
    vim.cmd'hi FlashLabel      guibg=#aaff55 guifg=#000000'
    vim.cmd'hi IncSearch       guibg=#caff00 guifg=#000000'
    vim.cmd'hi Search          guibg=#66d9ef guifg=#000000'
    vim.cmd'hi GitSignsAdd                   guifg=#a6da95'
    vim.cmd'hi GitSignsChange                guifg=#7dc4e4'
    vim.cmd'hi GitSignsDelete                guifg=#ed8796'
    vim.cmd'hi DiagnosticError               guifg=#ed8796'
    vim.cmd'hi DiagnosticWarn                guifg=#f5a97f'
    vim.cmd'hi DiagnosticInfo                guifg=#7dc4e4'
    vim.cmd'hi DiagnosticHint                guifg=#b7bdf8'
  end,
}

return module

