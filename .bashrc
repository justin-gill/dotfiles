# .bashrc
shopt -s histappend

if [ -f ~/.env ]; then
  . ~/.env
fi

HISTSIZE=10000
HISTFILESIZE=20000

LIGHT_BLUE="\[\e[38;5;153m\]"
PEACH="\[\e[38;5;174m\]"
LIGHT_GREEN="\[\e[38;5;151m\]"
RESET="\[\e[0m\]"

parse_git_branch() {
  local branch
  branch=$(git branch --show-current 2>/dev/null)

  if [[ -z "$branch" ]]; then
    return
  fi

  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    echo " $branch*"
  else
    echo " $branch"
  fi
}

PS1="${LIGHT_GREEN}\u@${LIGHT_GREEN}\h ${LIGHT_BLUE}\w${PEACH}\$(parse_git_branch) ${RESET}\$ "

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export GOPATH="$HOME/.go"
export CARGO_HOME="$HOME/.cargo"

PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PATH="$PATH:$HOME/.fzf/bin"
PATH="$PATH:$GOPATH/bin"
PATH="$PATH:$CARGO_HOME/bin"
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

if [[ $- == *i* ]]; then
  unset rc
  bind -x '"\C-f": tmux-sessionizer'
fi
alias vim='nvim'
alias vi='nvim'
alias ta='tmux a'
alias tx='tmux kill-server'
alias tf='terraform'
alias k='kubectl'
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion bash)
  complete -F __start_kubectl k
fi

export EDITOR='nvim'
export VISUAL='nvim'
export QT_STYLE_OVERRIDE=Adwaita-Dark

eval "$(mise activate bash)"

export DOTNET_ROOT=/usr/share/dotnet

complete -C /usr/bin/terraform terraform
alias assume='source assume'
alias kctx='kubectl config use-context $(kubectl config get-contexts -o name | fzf --height 40% --reverse --border)'

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash 2>/dev/null)"
fi

alias docker-compose='docker compose'
