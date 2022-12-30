health=6

# purple username
username() {
	echo "%{$FG[012]%}%n%{$reset_color%}"
}

# current directory, two levels deep
directory() {
	echo "%2~"
}

# current time with milliseconds
days_left() {
	echo $((31 - $(date +%d)))
}

hours_left() {
	echo $((24 - $(date +%H)))
}

minutes_left() {
	echo $((60 - $(date +%M)))
}
	
seconds_left() {
	echo $((60 - $(date +%S)))
}

time_until_xmas() {
  if (($health <= 0)); then
    echo %{$fg[red]%}"New Year is CANCELLED"%{$reset_color%}
  elif (($(days_left) < 0)); then
    echo "Happy New Year!"
  else
    echo 'until new year:' %{$fg[red]%}$(days_left)d %{$fg[yellow]%}$(hours_left)h %{$fg[green]%}$(minutes_left)m %{$fg[blue]%}$(seconds_left)s%{$reset_color%}
  fi
}

# returns E if there are errors, nothing otherwise
return_status() {
  echo "%(?..E)"
}

santa_health() {
  for (( i=1; i<$health; i++ ))
  do
    echo -n '🦌'
  done

  for (( i=$(( $health >= 1 ? health : 1 )); i<6; i++ ))
  do
    echo -n '💀'
  done
}

santa_face() {
  if (($health <= 0)); then
    echo "💀️"
  else
    echo "🎅"
  fi
}

# set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# putting it all together
PROMPT='%B$(username) $(directory)$(git_prompt_info)%b '
RPROMPT='$(santa_face) $(santa_health)   $(time_until_xmas)'

TMOUT=1

TRAPALRM() {
  zle reset-prompt
}

TRAPERR() {
  # shellcheck disable=SC2219
  let health=$(( health-1 >= 0 ? health-1 : 0 ))
  print -u2 Exit status: $?
}
