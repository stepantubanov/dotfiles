# -------------------------------------------------------------------
# Shell configuration
# -------------------------------------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt no_bg_nice # don't nice background tasks
setopt no_hup
setopt no_list_beep
setopt local_options # allow functions to have local options
setopt local_traps # allow functions to have local traps
setopt hist_verify
setopt share_history # share history between sessions ???
setopt extended_history # add timestamps to history
setopt prompt_subst
unsetopt correct
setopt complete_in_word
setopt ignore_eof

setopt append_history # adds history
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups  # don't record dupes in history
setopt hist_reduce_blanks

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

unsetopt correct_all

# bindkey '^[^[[D' backward-word
# bindkey '^[^[[C' forward-word
# bindkey '^[[5D' beginning-of-line
# bindkey '^[[5C' end-of-line
# bindkey '^[[3~' delete-char
# bindkey '^[^N' newtab
# bindkey '^?' backward-delete-char

source ~/.zsh/prompt.zsh

case $TERM in
  xterm*)
    precmd () {print -Pn "\e]0;%~\a"}
    ;;
esac

# Usage: git co**<TAB>
# https://github.com/junegunn/fzf/wiki/Examples-(completion)
_fzf_complete_git() {
    ARGS="$@"
    local branches
    branches=$(git branch -vv --all)
    if [[ $ARGS == 'git co'* ]]; then
        _fzf_complete --reverse --multi -- "$@" < <(
            echo $branches
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() {
    awk '{print $1}'
}

# -------------------------------------------------------------------
# Aliases
# -------------------------------------------------------------------

alias bi="bundle exec"
alias pg="postgres -D /usr/local/var/postgres"
alias q="exit"

alias wgup="wg-quick up wg0"
alias wgdown="wg-quick down wg0"

alias icat="kitty +kitten icat"

function swap() {
  local TMPFILE=tmp.$$
  mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}

function sudoswap() {
  local TMPFILE=tmp.$$
  sudo mv "$1" $TMPFILE && sudo mv "$2" "$1" && sudo mv $TMPFILE "$2"
}

export TERM="xterm-256color"
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#source /usr/local/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
#chruby "ruby-2.7.3"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.cargo/env
source ~/.zshrc-os
