# zmodload zsh/zprof

export ZSH=$HOME/.oh-my-zsh

DEFAULT_USER=$(whoami)

ZSH_THEME="yangmillstheory"

zstyle ':omz:update' mode disabled
# Disables re-hashing and re-compiling of Zsh functions within Oh My Zsh
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
setopt nocorrectall

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS=true

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY=true

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
plugins=(zsh-syntax-highlighting kubectl vim)

# zsh-completions isn't installed as a normal plugin to avoid issues with zcompdump.
#
# https://github.com/zsh-users/zsh-completions?tab=readme-ov-file#oh-my-zsh
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim

source ~/.functions.zsh
source ~/.aliases.zsh

unsetopt autopushd
export KEYTIMEOUT=1

# auto-suggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
bindkey '^A' autosuggest-accept

# allow S-Tab for reverse autocomplete navigation
# https://unix.stackexchange.com/a/84869
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

# fzf
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--reverse --border --preview-window right:50% --preview-window border'
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {}"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window hidden"
export FZF_CTRL_T_COMMAND="fd"
export FZF_CTRL_T_OPTS="--preview '$FZF_PREVIEW_COMMAND'"
export FZF_ALT_C_OPTS="--exit-0 --select-1 --preview 'tree -C -a {} | head -200'"
# https://github.com/junegunn/fzf/issues/492
setopt HIST_IGNORE_ALL_DUPS

# Just some direnv setup.
eval "$(direnv hook zsh)"

# --- Completion Setup (Consolidated and Optimized) ---

# Set up fpath completely before compinit
fpath=(~/.zsh/completions /opt/homebrew/share/zsh/site-functions $fpath)

# Add brew completions to fpath
if type brew &>/dev/null; then
    HOMEBREW_PREFIX=$(brew --prefix)
    fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
fi
# Add custom functions directory to fpath
fpath+=${ZDOTDIR:-~}/.zsh_functions

# Configure completion system caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
_comp_options+=(globdots)

# Run compinit ONCE to build/load the cache (fast load on subsequent starts)
autoload -Uz compinit
autoload -Uz zcompile

ZINIT_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
ZINIT_COMPDUMP_ZWC="${ZINIT_COMPDUMP}.zwc"
# Check if the compiled file is missing OR if the text dump is newer
if [[ ! -f "$ZINIT_COMPDUMP_ZWC" || "$ZINIT_COMPDUMP" -nt "$ZINIT_COMPDUMP_ZWC" ]]; then
    # Regenerate the plain text dump file (with -i to force dump and -D to skip compaudit)
    compinit -u -i -D
    # Byte-compile the new dump file
    if [[ -f "$ZINIT_COMPDUMP" ]]; then
        zcompile -R "$ZINIT_COMPDUMP"
    fi
else
    # Load from the compiled cache file (fastest path)
    # -C: Use the cache file
    # -D: Skip compaudit (extra layer of protection against the 18ms cost)
    compinit -u -C -D
fi

# 4. Set up fzf key bindings and fuzzy completion (Must be sourced after compinit)
source <(fzf --zsh)

# 5. Source external completion scripts
source <(localstack completion zsh)
complete -C `which aws_completer` aws
complete -C `which aws_completer` awslocal

# If needed, uncomment and run bashcompinit after compinit
# autoload bashcompinit && bashcompinit

# zprof
