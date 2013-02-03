export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt no_bg_nice # don't nice background tasks
setopt no_hup
setopt no_list_beep
setopt local_options # allow functions to have local options
setopt local_traps # allow functions to have local traps
setopt hist_verify
setopt share_history # share history between sessions ???
setopt extended_history # add timestamps to history
setopt prompt_subst
setopt correct
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

export PATH=/home/step/.rbenv/shims:/home/step/.rbenv/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
export RBXOPT="-X19"
export TERM="xterm-256color"

# Trying custom settings for Ruby
export RUBY_GC_MALLOC_LIMIT=50000000
export RUBY_HEAP_MIN_SLOTS=500000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_HEAP_SLOTS_INCREMENT=250000

# Node
export NODE_PATH=$NODE_PATH:/usr/lib/node_modules

# zsh keys
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char