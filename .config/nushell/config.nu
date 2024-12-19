# settings
$env.config = {
  show_banner: false,
  edit_mode: vi,
}

alias e = editor
alias p = pueue
alias pd = pueue remove
alias pa = pueue add
alias pga = pueue group add
alias pgd = pueue group remove
alias pp = pueue parallel
# alias rl = source ~/.config/fish/config.fish
# alias in = tmux-in
# alias out = tmux-out
# alias td = tmux-delete
alias tk = tmux kill-server
alias tl = tmux list-sessions
# alias tn = 'tmux display-message -p \'#S\
alias fixnvr = rm -f /tmp/nvimsocket
# alias phpv = switch-php-version

def editor [...argv] {
  if ('/tmp/nvimsocket' | path exists) {
    nvr --remote $argv
  } else {
    nvim --listen /tmp/nvimsocket $argv
  }
}

if (uname | get kernel-name) == 'Linux' {
  $env.PATH = ($env.PATH | prepend '/home/linuxbrew/.linuxbrew/bin')
}

