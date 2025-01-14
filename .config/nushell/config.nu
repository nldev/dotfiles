# settings
$env.config = {
  show_banner: false,
  edit_mode: vi,
}



# aliases
alias e = editor
alias p = pueue
alias pd = pueue remove
alias pa = pueue add
alias pga = pueue group add
alias pgd = pueue group remove
alias pp = pueue parallel
alias tk = tmux kill-server
alias tl = tmux list-sessions
alias fixnvr = rm -f /tmp/nvimsocket



# neovim
def editor [...argv] {
  if ('/tmp/nvimsocket' | path exists) {
    nvr --remote $argv
  } else {
    nvim --listen /tmp/nvimsocket $argv
  }
}



# package management
if (uname | get kernel-name) == 'Linux' {
  $env.PATH = ($env.PATH | prepend '/home/linuxbrew/.linuxbrew/bin')
}



# contexts
for $x in (fd \.nu$ $'($env.HOME)/.contexts' | split row "\n") {
  echo $"source ($x)\n" | save -f $'($env.HOME)/.config/nushell/contexts.nu --append --raw'
}
source ~/.config/nushell/contexts.nu

