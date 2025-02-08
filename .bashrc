# .bashrc
shopt -s histappend

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

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
  branch=$(git branch 2>/dev/null | grep -e '^\*' | sed 's/^\* //')

  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    echo "$branch*"
  else
    echo "$branch"
  fi
}

PS1="${LIGHT_GREEN}\u@${LIGHT_GREEN}\h ${LIGHT_BLUE}\w${PEACH}\$([ -n \"\$(git branch 2>/dev/null)\" ] && echo \" \$(parse_git_branch)\") ${RESET}\$ "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
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

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
bind -x '"\C-f": tmux-sessionizer'
alias vim='nvim'
alias vi='nvim'
alias ta='tmux a'

export EDITOR='vim'
export VISUAL='vim'
export QT_STYLE_OVERRIDE=Adwaita-Dark

function was() {
    ~/.cargo/bin/wa-cli -s query "$*"
}

function wa() {
    ~/.cargo/bin/wa-cli query "$*"
}

eval "$(mise activate bash)"

