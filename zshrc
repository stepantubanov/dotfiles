# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

# Customize to your needs...
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

# ---------------------------------------------------------------------------
# Pretty Git Log (grb)
# ---------------------------------------------------------------------------
# Log output:
#
# * 51c333e    (12 days)    <Gary Bernhardt>   add vim-eunuch
#
# The time massaging regexes start with ^[^<]* because that ensures that they
# only operate before the first "<". That "<" will be the beginning of the
# author name, ensuring that we don't destroy anything in the commit message
# that looks like time.
#
# The log format uses } characters between each field, and `column` is later
# used to split on them. A } in the commit subject or any other field will
# break this.

glog() {
  local commit_hash="%C(yellow)%h%Creset"
  local relative_time="%Cgreen(%ar)%Creset"
  local author="%C(bold blue)<%an>%Creset"
  local refs="%C(red)%d%Creset"
  local subject="%s"

  local format="$commit_hash}$relative_time}$author}$refs $subject"
  git log --graph --pretty="tformat:${format}" $* |
      # Replace (2 years ago) with (2 years)
      sed -Ee 's/(^[^<]*) ago\)/\1)/' |
      # Replace (2 years, 5 months) with (2 years)
      sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?\)/\1)/' |
      # Line columns up based on } delimiter
      column -s '}' -t |
      # Page only if we need to
      less -FXRS
}

# Only 15 last
alias glor="glog -15"
