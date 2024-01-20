# The oh-my-zsh vim plugin uses this.
MODE_INDICATOR="%{$fg_bold[red]%}NORMAL%{$reset_color%}"

# Show the time that the command was run; then reset RPS1 using the function in
# the vim plugin.
reset-prompt-and-accept-line() {
    RPS1='[%D{%L:%M:%S %p}]'
    zle reset-prompt
    zle accept-line
    RPS1='$(vi_mode_prompt_info)'
}

zle -N reset-prompt-and-accept-line
bindkey '^m' reset-prompt-and-accept-line

# enable command substitution (and other expansions) in PROMPT
setopt prompt_subst
local upper_arrow="%(?:%{$fg_bold[green]%}┌─ :%{$fg_bold[red]%}┌─ )%{$reset_color%}"
local lower_arrow="%(?:%{$fg_bold[green]%}└─➤ :%{$fg_bold[red]%}└%?─➤ )%{$reset_color%}"
PROMPT="$upper_arrow"'%{$fg[cyan]%}[%m] %{$fg_bold[magenta]%}$(echo $PWD | sed "s|^$HOME|~|" | perl -pe "s/(\w)[^\/]+\//\1\//g")%{$reset_color%} $(git_prompt_info)'$'\n'"$lower_arrow"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
