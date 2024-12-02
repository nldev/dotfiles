# settings
set fish_greeting ''



# homebrew
if test (uname) = 'Linux'
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end



# aliases
alias e='editor'
alias p='pueue'
alias pd='pueue remove'
alias pa='pueue add'
alias pga='pueue group add'
alias pgd='pueue group remove'
alias pp='pueue parallel'
alias rl='source ~/.config/fish/config.fish'
alias in='tmux-in'
alias out='tmux-out'
alias td='tmux-delete'
alias tk='tmux-kill'
alias tka='tmux-kill-all'
alias tl='ls /tmp/tmux-1000'
alias tn='tmux display-message -p \'#S\''
alias fixnvr='rm -f /tmp/nvimsocket'
alias phpv='switch-php-version'



# paths
set -U fish_user_paths $fish_user_paths ~/.config/composer/vendor/bin
set -U fish_user_paths $fish_user_paths ~/.config/emacs/bin



# neovim
function editor
  if test -S /tmp/nvimsocket
    nvr --remote $argv
  else
    nvim --listen /tmp/nvimsocket $argv
  end
end



# tmux
function tmux-in
  set -l session_name $argv[1]
  if test -z "$session_name"
    set session_name main
  end
  if tmux -L $session_name has-session -t $session_name 2>/dev/null
    if test "$session_name" = "main"
      tmux -L $session_name attach-session -t main
    else
      tmux -L $session_name attach-session -t $session_name
    end
  else
    if test "$session_name" = "main"
      cd ~
      fixnvr
      if not pgrep pueued > /dev/null
        pueued -d > /dev/null 2>&1
      end
      tmux new-session -d -s main -n vim 'rm -f /tmp/nvimsocket; fish -c "e; fish"'
      tmux new-window -t main:9 -n emacs 'fish -c "emacs; fish"'
      tmux select-window -t main:0
      tmux attach-session -t $session_name
    else
      tmux -L $session_name -f $HOME/.tmux.nested.conf new-session -d -s $session_name -n fish 'fish'
      tmux -L $session_name attach-session -t $session_name
    end
  end
end

function tmux-out
  if tmux info &>/dev/null
    tmux detach
  else
    echo 'Not in a tmux session.'
  end
end

function tmux-delete
  set -l session_name $argv[1]
  if test -z "$session_name"
    set session_name main
  end
  if test "$session_name" = "main"
    tmux kill-session -t main
  else
    tmux -L $session_name kill-session -t $session_name
  end
end

function tmux-kill
  set -l session_name $argv[1]
  if test -z "$session_name"
    set session_name main
  end
  if test "$session_name" = "main"
    tmux -L default kill-server
    rm -f /tmp/tmux-1000/default
  else
    tmux -L $session_name kill-session -t $session_name
    rm -f /tmp/tmux-1000/$session_name
  end
end

function tmux-kill-all
  for file in /tmp/tmux-1000/*
    set session_name (basename $file)
    tmux -L $session_name kill-server
  end
end



# php
function switch-php-version
  if test (count $argv) -eq 0
    echo 'Usage: switch-php-version <version>'
    return 1
  end
  set php_version $argv[1]
  set brew_php_path (brew --prefix php@$php_version)
  if not test -d $brew_php_path
      echo "PHP $php_version not installed. Installing..."
      brew install php@$php_version
  end
  echo "Switching to PHP $php_version..."
  brew unlink php > /dev/null 2>&1
  brew link --force --overwrite php@$php_version
  php -v
end



# yadm
function check-yadm-updates
  yadm fetch > /dev/null 2>&1
  set local_commit (yadm rev-parse @)
  set remote_commit (yadm rev-parse @{u})
  if test "$local_commit" != "$remote_commit"
      echo "Your yadm repo is not up-to-date with the remote. Run 'yadm pull' to sync."
  end
end

check-yadm-updates



# fzf
fzf --fish | source



# zoxide
zoxide init fish | source



# wsl only
function is-wsl
  if test -e /proc/sys/fs/binfmt_misc/WSLInterop
    return 0
  end
  return 1
end

if test -d /mnt/e/sync/notes/me
#  if is-wsl
#    if not mountpoint -q /home/$USER/notes
#      sudo mount --bind /mnt/e/sync/notes/me /home/$USER/notes
#    end
#  end
end



# arch linux only
if string match -q "*ARCH*" $os_info
  alias pac='yay -S --noconfirm --answeredit No'
  alias unpac='sudo pacman -Rns --noconfirm'
  return 0
end

