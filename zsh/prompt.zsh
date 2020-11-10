git_dirty() {
  if [[ -n $(git status -s 2>/dev/null) ]]; then
    echo "%{\e[38;5;214m%}*"
  else
    echo ""
  fi
}

git_prompt_info () {
  ref=$(/usr/bin/git symbolic-ref HEAD 2>/dev/null) || return
  echo "%{\e[0m%} on %{\e[01m%}%{\e[38;5;153m%}%{%G%} ${ref#refs/heads/}$(git_dirty)"
}

#export PROMPT=$'$FX[bold]$FG[075]%c $(git_prompt_info)$FG[105]%(!.#.»)$FX[reset]%{$reset_color%} '
export PROMPT=$'%{\e[01m%}%{\e[38;5;81m%}${PWD/#$HOME/~}$(git_prompt_info)%{\e[0m%} '
