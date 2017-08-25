#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

export LSCOLORS=fxfxcxdxcxegedabagacad
export PATH=~/bin:$PATH

alias vim='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
