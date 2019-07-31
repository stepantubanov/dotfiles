export ZSH=$HOME/dotfiles/zsh

source $ZSH/colors.zsh
source $ZSH/config.zsh
source $ZSH/aliases.zsh
source $ZSH/prompt.zsh

### Added by the Heroku Toolbelt
export PATH="/usr/local/bin:/usr/local/heroku/bin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/usr/local/opt/node@8/bin:$PATH"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

eval $(docker-machine env default)
export DOCKER_BUILDKIT=1
