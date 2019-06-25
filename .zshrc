#
# User configuration sourced by interactive shells
#

# Define zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

#export LSCOLORS=fxfxcxdxcxegedabagacad
export PATH=~/bin:$PATH
export GPG_TTY=$(tty)

alias vim='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
