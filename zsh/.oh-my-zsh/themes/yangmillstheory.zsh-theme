setopt prompt_subst
local upper_arrow="%(?:%{$fg_bold[green]%}╭━ :%{$fg_bold[red]%}╭━ )%{$reset_color%}"
local lower_arrow="%(?:%{$fg_bold[green]%}╰➜ :%{$fg_bold[red]%}╰%?➜ )%{$reset_color%}"
PROMPT="$upper_arrow"'%{$fg_bold[yellow]%}%m %{$fg[cyan]%}$(shrink_path -f)%{$reset_color%} $(git_prompt_info)'$'\n'"$lower_arrow"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
