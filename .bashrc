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
export GOPATH="$HOME/.go"
export CARGO_HOME="$HOME/.cargo"
# Prepend once so nested shells don't duplicate entries; last listed wins.
for dir in "$CARGO_HOME/bin" "$GOPATH/bin" "$HOME/.local/bin"; do
  case ":$PATH:" in
    *":$dir:"*) ;;
    *) PATH="$dir:$PATH" ;;
  esac
done
unset dir
export PATH

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
case ";${PROMPT_COMMAND:-};" in
  *"history -a"*) ;;
  *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# Prompt
LIGHT_BLUE="\[\e[38;5;153m\]"
PEACH="\[\e[38;5;174m\]"
LIGHT_GREEN="\[\e[38;5;151m\]"
RESET="\[\e[0m\]"

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  . /usr/share/git/completion/git-prompt.sh
elif [ -f /usr/lib/git-core/git-sh-prompt ]; then
  . /usr/lib/git-core/git-sh-prompt
fi
command -v __git_ps1 >/dev/null 2>&1 || __git_ps1() { :; }
export GIT_PS1_SHOWDIRTYSTATE=1
PS1="${LIGHT_GREEN}\u@${LIGHT_GREEN}\h ${LIGHT_BLUE}\w${PEACH}\$(__git_ps1 ' %s') ${RESET}\$ "

# Aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
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
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

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
