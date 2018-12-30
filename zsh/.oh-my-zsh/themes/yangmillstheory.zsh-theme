google3_prompt_info() {
  if [[ $PWD =~ '/google/src/cloud/[^/]+/(.+)/google3(.*)' ]]; then
    print -r -- "%F{blue}($match[1]) %F{green}//${match[2]#/}"
  else
    print -r -- "%F{green}$(shrink_path -f)"
  fi
}

# enable command substitution (and other expansions) in PROMPT
setopt prompt_subst
local upper_arrow="%(?:%{$fg_bold[green]%}╭─ :%{$fg_bold[red]%}╭─ )%{$reset_color%}"
local lower_arrow="%(?:%{$fg_bold[green]%}╰→ :%{$fg_bold[red]%}╰%?→ )%{$reset_color%}"
PROMPT="$upper_arrow"'%{$fg_bold[yellow]%}%m %{$fg[cyan]%}$(google3_prompt_info)%{$reset_color%} $(git_prompt_info)'$'\n'"$lower_arrow"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
