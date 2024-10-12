local module = {
  name = 'statusline',
  desc = 'configures the status line',
  plugins = {},
  dependencies = { 'git' },
  fn = function ()
    -- file path and modified flag
    vim.opt.statusline = '%f%m '

    -- git branch name (only if inside repo)
    vim.opt.statusline:append('%{get(b:,"gitsigns_head","") != "" ? "<".get(b:,"gitsigns_head","").">" : ""} ')

    -- git status
    vim.opt.statusline:append('%{get(b:,"gitsigns_status","")}')

    -- right-align remaining statusline
    vim.opt.statusline:append('%=')

    -- buffer language
    vim.opt.statusline:append('%{!empty(&filetype) ? &filetype : &buftype} ')

    -- hex value of char under cursor
    vim.opt.statusline:append('[0x%B] ')

    -- buffer number
    vim.opt.statusline:append('B:%n ')

    -- current line / total lines
    vim.opt.statusline:append('L:%l/%L ')

    -- column number
    vim.opt.statusline:append('C:%v ')

    -- percentage through the file
    vim.opt.statusline:append('[%p%%]')
  end,
}

return module

