autoload colors && colors

# Git info

git_dirty() {
  if [[ -n $(git status -s 2>/dev/null) ]]; then
    echo "$FG[214]*"
  else
    echo ""
  fi
}

git_prompt_info () {
  ref=$(/usr/bin/git symbolic-ref HEAD 2>/dev/null) || return
  echo "$FG[075]branch:(${ref#refs/heads/}$(git_dirty)$FG[075]) "
}

# Vim mode

vim_ins_mode="%{$fg[cyan]%}[INS]%{$reset_color%}"
vim_cmd_mode="%{$fg[green]%}[CMD]%{$reset_color%}"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish


export PROMPT=$'$FX[bold]$FG[032]%c $(git_prompt_info)$FG[105]%(!.#.»)$FX[reset]%{$reset_color%} '
