virtualenv_prompt_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%{$fg_bold[cyan]%}(venv:$(basename "$VIRTUAL_ENV"))%{$reset_color%} "
  fi
}


# The oh-my-zsh vim plugin uses this.
MODE_INDICATOR="%{$fg_bold[red]%}NORMAL%{$reset_color%}"

# Show the time that the command was run; then reset RPS1 using the function in
# the vim plugin.
reset-prompt-and-accept-line() {
    RPS1=$'%{\x1b[3m%}%{$fg[yellow]%}[%D{%L:%M:%S %p}]%{$reset_color%}%{\x1b[0m%}'
    zle reset-prompt
    zle accept-line
    RPS1='$(vi_mode_prompt_info)'
}

zle -N reset-prompt-and-accept-line
bindkey '^m' reset-prompt-and-accept-line

# enable command substitution (and other expansions) in PROMPT
setopt prompt_subst
local upper_arrow="%(?:%{$fg[green]%}┌─ :%{$fg[red]%}┌─ )%{$reset_color%}"
local lower_arrow="%(?:%{$fg[green]%}└─➤ :%{$fg[red]%}└%?─➤ )%{$reset_color%} "
# PROMPT="$upper_arrow"'%{$fg_bold[yellow]%}[$(shortpath)] $(git_prompt_info)'$'\n'"$lower_arrow"
PROMPT="$upper_arrow"'%{$fg_bold[yellow]%}[$(shortpath)] $(virtualenv_prompt_info)$(git_prompt_info)'$'\n'"$lower_arrow"


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Modifications to python virtualenv.
export VIRTUAL_ENV_DISABLE_PROMPT=1
