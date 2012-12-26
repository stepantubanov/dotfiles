autoload colors && colors

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

unpushed () {
  /usr/bin/git cherry -v origin/$(git_branch) 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg[green]%}unpushed%{$reset_color%} "
  fi
}

# export PROMPT=$'$(git_dirty)› '
# export PROMPT=$'\n$(rbenv_prompt) in $(directory_name) $(git_dirty)$(need_push)\n› '
# export PROMPT=$'%{$fg[blue]%}%m%{$reset_color%}:%{$fg[white]%}%c%{$reset_color%}$(git_dirty) %{$fg[white]%}›%{$reset_color%} '

export PROMPT=$'$FX[bold]$FG[032]%c $(git_prompt_info)$FG[105]%(!.#.»)$FX[reset]%{$reset_color%} '
