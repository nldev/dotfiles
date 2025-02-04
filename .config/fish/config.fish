# settings
set fish_greeting ''



# variables
## constants
set DOCKER_DIR '/mnt/e/sync/docker'
## tmux
set -gx IS_TMUX_REMOTE 0
if test $SSH_CLIENT
  set -gx IS_TMUX_REMOTE 1
else
  set -gx IS_TMUX_REMOTE 0
end
## windows
set -gx IS_WSL 0
if test -e /proc/sys/fs/binfmt_misc/WSLInterop
  set -gx IS_WSL 0
else
  set -gx IS_WSL 1
end
## mac
set -gx IS_MAC 0
if test (uname) = 'Darwin'
  set -gx IS_MAC 1
end
## linux
set -gx IS_LINUX 0
set -gx IS_ARCH_LINUX 0
if test (uname) = "Linux"
  set -gx IS_LINUX 1
  if string match -q "*ARCH*" $os_info
    set -gx IS_ARCH_LINUX 1
  else
    set -gx IS_ARCH_LINUX 0
  end
else
  set -gx IS_LINUX 0
end



# package management
if test $IS_MAC -eq 1
  eval "$(/opt/homebrew/bin/brew shellenv)"
end
if test $IS_LINUX -eq 1
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end
if test $IS_ARCH_LINUX -eq 1
  alias pac='yay -S --noconfirm --answeredit No'
  alias unpac='sudo pacman -Rns --noconfirm'
end



# commands
bind \cz 'fg; commandline -f repaint'



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
set -U fish_user_paths $fish_user_paths /opt/homebrew/bin
set -U fish_user_paths $fish_user_paths ~/.config/emacs/bin



# neovim
function editor
  if test -S /tmp/nvimsocket
    nvr $argv
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
    tmux -L $session_name attach-session -t $session_name
  else
    if test "$session_name" = "main"
      cd ~
      fixnvr
      if not pgrep pueued > /dev/null
        pueued -d > /dev/null 2>&1
      end
      tmux -L $session_name new-session -d -s main -n vim 'rm -f /tmp/nvimsocket; fish -c "e; fish"'
      tmux -L $session_name select-window -t main:0
      tmux -L $session_name attach-session -t $session_name
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
  tmux -L $session_name kill-session -t $session_name
end

function tmux-kill
  set -l session_name $argv[1]
  if test -z "$session_name"
    set session_name main
  end
  tmux -L $session_name kill-session -t $session_name
  rm -f /tmp/tmux-1000/$session_name
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



# yt-dlp
function play
  if test $IS_WSL
    if not test -e /mnt/e/app/mpv/mpv.exe
      echo 'Error: mpv.exe is not installed or not in PATH'
      return 1
    end
    if not command -v yt-dlp > /dev/null
      echo 'Error: yt-dlp is not installed or not in PATH'
      return 1
    end
    set -l url $argv[1]
    set -l name (yt-dlp --no-warnings --get-title $url)
    set -l file /tmp/$name.mp4
    if not test -e $file
      yt-dlp --progress --no-warnings --quiet -o $file $url
    end
    fish -c "/mnt/e/app/mpv/mpv.exe '$file' 2&>1" &
  end
end



# starship
starship init fish | source



# contexts
if test -d ~/.contexts
  for repo in ~/.contexts/*
    if test -d $repo/config/fish
      test -f $repo/config/fish/init.fish; and source $repo/config/fish/init.fish
    end
  end
end

