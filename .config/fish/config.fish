# settings
set fish_greeting ''


# homebrew
if test (uname) = 'Linux'
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end



# aliases
alias rl='source ~/.config/fish/config.fish'
alias in='tmuxin'
alias out='tmuxout'
alias td='tmux detach-client -a -s main'
alias tk='tmux kill-server'
alias pac='yay -S --noconfirm --answeredit No'
alias unpac='sudo pacman -Rns --noconfirm'
alias fixnvr='rm -f /tmp/nvimsocket'



# neovim
function e 
  if test -S /tmp/nvimsocket
    nvr --remote "$argv"
  else
    nvim --listen /tmp/nvimsocket "$argv"
  end
end



# tmux
function tmuxin
  if tmux has-session -t main 2>/dev/null
    tmux attach-session -t main
  else
    tmux new-session -s main -n fish -d  'fish'
    tmux new-window -t main:1 -n vim 'fish -c "nvim --listen /tmp/nvimsocket; fish"'
    tmux new-window -t main:2 -n task 'fish -c "taskwarrior-tui; fish"'
    tmux new-window -t main:3 -n mail 'fish' # FIXME: implement
    tmux select-window -t main:1
    tmux attach-session -t main
  end
end

function tmuxout
    if tmux info &>/dev/null
        tmux detach
    else
        echo 'Not in a tmux session.'
    end
end



# yadm
function check_yadm_updates
    yadm fetch > /dev/null 2>&1
    set local_commit (yadm rev-parse @)
    set remote_commit (yadm rev-parse @{u})
    if test "$local_commit" != "$remote_commit"
        echo 'Your yadm repo is not up-to-date with the remote. Run "yadm pull" to sync.'
    end
end

check_yadm_updates



# fzf
fzf --fish | source

