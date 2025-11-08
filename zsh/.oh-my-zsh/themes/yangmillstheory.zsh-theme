# --- Virtualenv + AWS prompt helpers ---
virtualenv_prompt_info() {
  [[ -n "$VIRTUAL_ENV" ]] || return
  print -n "%{$fg_bold[cyan]%}venv:%{$fg[red]%}($(basename ${VIRTUAL_ENV:A}))%{$reset_color%} "
}
aws_vault_prompt_info() {
  [[ -n "$AWS_VAULT" ]] || return
  print -n "%{$fg_bold[magenta]%}aws-vault:%{$fg[red]%}($AWS_VAULT)%{$reset_color%} "
}

# --- Mode indicator (used by vim plugin) ---
MODE_INDICATOR="%{$fg_bold[red]%}NORMAL%{$reset_color%}"

# --- Return timestamp after each command ---
reset-prompt-and-accept-line() {
  local saved_rps1=$RPS1
  RPS1=$'%{\x1b[3m%}%{$fg[yellow]%}[%D{%L:%M:%S %p}]%{$reset_color%}%{\x1b[0m%}'
  zle reset-prompt
  zle accept-line
  RPS1=$saved_rps1
}
zle -N reset-prompt-and-accept-line
bindkey '^m' reset-prompt-and-accept-line

# --- Enable substitutions in prompt ---
setopt prompt_subst

# --- Main prompt ---
PROMPT='%(?:%{$fg[green]%}┌─ :%{$fg[red]%}┌─ )%{$reset_color%}'\
'%{$fg_bold[yellow]%}[$(shortpath)] $(virtualenv_prompt_info)$(aws_vault_prompt_info)$(git_prompt_info)'$'\n'\
'%(?:%{$fg[green]%}└─➤ :%{$fg[red]%}└%?─➤ )%{$reset_color%} '

# --- Git colors ---
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

export VIRTUAL_ENV_DISABLE_PROMPT=1
