[[ $- != *i* ]] && return

# System configurations
if [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
elif [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if ! shopt -oq posix && [ -z "${BASH_COMPLETION_VERSINFO-}" ]; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Environment variables
export BROWSER="firefox"
export EDITOR="nvim"
export VISUAL="nvim"
export QT_STYLE_OVERRIDE="Adwaita-Dark"
export GOPATH="$HOME/.go"
export CARGO_HOME="$HOME/.cargo"
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.fzf/bin:$GOPATH/bin:$CARGO_HOME/bin:$PATH"

export NEWT_COLORS='
  root=,#1e1e2e; window=#cdd6f4,#181825; shadow=#1e1e2e,#1e1e2e;
  title=#cba6f7,#181825; label=#bac2de,#181825; textbox=#cdd6f4,#181825;
  acttextbox=#1e1e2e,#89b4fa; entry=#1e1e2e,#89b4fa; disentry=#bac2de,#313244;
  listbox=#cdd6f4,#181825; actsellistbox=#1e1e2e,#f9e2af; button=#cdd6f4,#313244;
  actbutton=#1e1e2e,#a6e3a1; compactbutton=#cdd6f4,#313244; actcompactbutton=#1e1e2e,#89b4fa;
  checkbox=#bac2de,#181825; actcheckbox=#1e1e2e,#a6e3a1;
'

# Bash behavior & history
shopt -s histappend
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:-}"

# Prompt
LIGHT_BLUE="\[\e[38;5;153m\]"
PEACH="\[\e[38;5;174m\]"
LIGHT_GREEN="\[\e[38;5;151m\]"
RESET="\[\e[0m\]"

parse_git_branch() {
  local branch
  branch=$(git branch --show-current 2>/dev/null)
  [[ -z "$branch" ]] && return

  if git rev-parse --quiet --verify HEAD >/dev/null && ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo " $branch*"
  else
    echo " $branch"
  fi
}
PS1="${LIGHT_GREEN}\u@${LIGHT_GREEN}\h ${LIGHT_BLUE}\w${PEACH}\$(parse_git_branch) ${RESET}\$ "

# Aliases
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
alias ..='cd ..'
alias vim='nvim'
alias vi='nvim'
alias ta='tmux a'
alias tx='tmux kill-server'
alias docker-compose='docker compose'

# Keybindings
bind -x '"\C-f": tmux-sessionizer'

# Tool initializations & completions
eval "$(mise activate bash)"

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash 2>/dev/null)"
fi

# Local includes
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    [ -f "$rc" ] && . "$rc"
  done
  unset rc
fi

if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi
