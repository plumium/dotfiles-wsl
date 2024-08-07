# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# functions
get_current_git_branch(){
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "$(git branch | grep -Po '(?<=\*\s).*$')"
    fi
}

mcd() {
    mkdir "$@" 2> >(sed s/mkdir/mcd/ 1>&2) && cd "$_"
}

cyan(){
    echo -e "\[\e[1;36m\]$1\[\e[m\]"
}

blue(){
    echo -e "\[\e[1;34m\]$1\[\e[m\]"
}

# aliases
alias clip="/mnt/c/Windows/System32/clip.exe"
alias explorer="/mnt/c/Windows/explorer.exe"
alias pwsh="/mnt/c/Program\ Files/PowerShell/7/pwsh.exe"
if command -v vim >/dev/null; then
  alias vi=$(command -v vim)
  export GIT_EDITOR=$(command -v vim)
  export EDITOR=$(command -v vim)
fi

# export variables
export PS1="$(cyan \\w)\[\e[91m\]\$(__git_ps1)\[\e[m\]\n$(blue '>') "
export PROMPT_COMMAND='echo -en "\e[3 q""\n"'

export GIT_PS1_SHOWDIRTYSTATE=1
export KERL_BUILD_DOCS=yes

if command -v pwsh 2>&1 >/dev/null; then
  # Remove CR using NoNewLine option to avoid moving cursor to the beginning of the line
  export WINHOME=$(wslpath $(pwsh -NoLogo -NoProfile -c \
    'Write-Host -NoNewLine $env:USERPROFILE'))
      export PATH="$PATH:$WINHOME/AppData/Local/Programs/Microsoft VS Code/bin"
fi

p=$(
IFS=','
a=(
  "$PATH",
  "$HOME/go/bin",
  "$HOME/.config/elixir/ls/rel",
  ""
  )
  echo ${a[@]}
)
export PATH=$(echo $p | tr ' ' ':')

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

[ -f ~/.asdf/asdf.sh ] && source ~/.asdf/asdf.sh
[ -f ~/.asdf/completions/asdf.bash ] && source ~/.asdf/completions/asdf.bash

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

complete -C ~/go/bin/gocomplete go
eval "$(vfox activate bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Check if pam_systemd has failed to set XDG_RUNTIME_DIR
if [ -z "$XDG_RUNTIME_DIR" ]; then
  echo 'XDG_RUNTIME_DIR is not set'
  export XDG_RUNTIME_DIR="/run/user/$UID"
  echo "Set XDG_RUNTIME_DIR to $XDG_RUNTIME_DIR"
fi

# Ensure the directory exists for zellij to start properly
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
  echo "$XDG_RUNTIME_DIR does not exist"
  sudo mkdir -p "$XDG_RUNTIME_DIR"
  sudo chown "$UID:$UID" "$XDG_RUNTIME_DIR"
  echo "Created $XDG_RUNTIME_DIR"
fi
