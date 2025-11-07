# zmodload zsh/zprof
#
export ZSH=$HOME/.oh-my-zsh

DEFAULT_USER=$(whoami)

ZSH_THEME="yangmillstheory"

zstyle ':omz:update' mode disabled
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

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh
#
# zsh-syntax-highlighting needs to be last
plugins=(kubectl vim zsh-syntax-highlighting)

# zsh-completions isn't installed as a normal plugin to avoid issues with zcompdump.
#
# https://github.com/zsh-users/zsh-completions?tab=readme-ov-file#oh-my-zsh
fpath+=${ZSH}/custom/plugins/zsh-completions/src
# Set up fpath completely before compinit
fpath=(~/.zsh/completions /opt/homebrew/share/zsh/site-functions $fpath)
# Add brew completions to fpath
if type brew &>/dev/null; then
    HOMEBREW_PREFIX=$(brew --prefix)
    fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
fi
# Add custom functions directory to fpath

fpath+=${ZDOTDIR:-~}/.zsh_functions

zstyle ':completion:*' use-cache on
_comp_options+=(globdots)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim

source ~/.functions.zsh
source ~/.aliases.zsh

unsetopt autopushd
export KEYTIMEOUT=1

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

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Source external completion scripts
source <(localstack completion zsh)
complete -C `which aws_completer` aws
complete -C `which aws_completer` awslocal

source /Users/victor.alvarez/.jfrog/jfrog_zsh_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/victor.alvarez/code/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/victor.alvarez/code/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/victor.alvarez/code/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/victor.alvarez/code/google-cloud-sdk/completion.zsh.inc'; fi

# zprof
