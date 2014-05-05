# $HOME/.bashrc
# This file will be sourced each time bash_profile is run.

# Source only regular readable files in 'file'
for file in {/etc/bashrc,$HOME/.bash_functions,}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Add bash-completion to the environment.
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Set $PATH to call user installed programs, comment out to set $PATH back to default
# Otherwise $PATH comes from /etc/paths, then etc/paths.d. See 'man path_helper' for OSX 10.9+
export PATH=/usr/local/bin:/usr/local/CrossPack-AVR/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin

# Directory aliases.
alias dotfiles="cd ~/dotfiles/"

# Command aliases.
alias ..="cd .."
alias ...="cd ../.."
alias flushdns="dscacheutil -flushcache"
alias grep="grep --color=auto"
alias h="history | tail -20"
alias l="ls -aG"
alias ll="ls -aGhl"
alias mv="mv -iv"
alias hidedotfiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias showdotfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias which="which -a"
alias v="vim ."

# ENV variables
export CLICOLOR=1
export EDITOR="vim"
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL="ignoreboth"
export HISTIGNORE="-:..:...:cd:cd *:fg:h:l:ll:ls:v"
export LSCOLORS=gxfxcxdxbxegedabagacad
export VISUAL="vim"

# Colors
BLACK="\[\e[0;30m\]"
RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
PURPLE="\[\e[0;35m\]"
CYAN="\[\e[0;36m\]"
WHITE="\[\e[0;37m\]"
RESET="\[\e[0m\]"

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# TMUX
[ -z "$TMUX" ] && export TERM=xterm-256color

# Git, ensure 'brew install bash-completion' has run or sources may fail!
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_UNTRACKEDFILES=true

# PS1 Prompt, the reset is required for git prompt coloring
PROMPT_COMMAND="$PROMPT_COMMAND __git_ps1 \
                '${CYAN}\w${RESET}' \
                ' ${YELLOW}\$${RESET} '"

