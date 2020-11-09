export ZSH=$HOME/.dotfiles/zsh

source $ZSH/colors.zsh
source $ZSH/config.zsh
source $ZSH/aliases.zsh
source $ZSH/prompt.zsh
source ~/.zshrc-os

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export FZF_DEFAULT_COMMAND='rg --files'

source /usr/local/share/chruby/chruby.sh
chruby "ruby-2.7.1"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
