# settings
set fish_greeting ''



# homebrew
if test (uname) = 'Linux'
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end



# aliases
alias e='edit-file'
alias rl='source ~/.config/fish/config.fish'
alias in='tmux-in'
alias out='tmux-out'
alias td='tmux detach-client -a -s main'
alias tk='tmux kill-server'
alias fixnvr='rm -f /tmp/nvimsocket'
alias phpv='switch-php-version'
# alias pac='yay -S --noconfirm --answeredit No'
# alias unpac='sudo pacman -Rns --noconfirm'



# neovim
function edit-file
  if test -S /tmp/nvimsocket
    nvr --remote "$argv"
  else
    nvim --listen /tmp/nvimsocket "$argv"
  end
end



# tmux
function tmux-in
  if tmux has-session -t main 2>/dev/null
    tmux attach-session -t main
  else
    tmux new-session -d -s main -n vim 'fish -c "nvim --listen /tmp/nvimsocket; fish"'
    tmux new-window -t main:1 -n mail 'fish'
    tmux select-window -t main:0
    tmux attach-session -t main
  end
end

function tmux-out
  if tmux info &>/dev/null
    tmux detach
  else
    echo 'Not in a tmux session.'
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
function check_yadm_updates
  yadm fetch > /dev/null 2>&1
  set local_commit (yadm rev-parse @)
  set remote_commit (yadm rev-parse @{u})
  if test "$local_commit" != "$remote_commit"
      echo "Your yadm repo is not up-to-date with the remote. Run 'yadm pull' to sync."
  end
end

check_yadm_updates



# fzf
fzf --fish | source

