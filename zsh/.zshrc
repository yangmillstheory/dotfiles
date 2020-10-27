# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

DEFAULT_USER=$(whoami)

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="yangmillstheory"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
setopt nocorrectall

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # remember that these have to be manually installed
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
  vim
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR=nvim
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source ~/.functions
source ~/.aliases

# https://superuser.com/questions/401699/oh-my-zsh-turned-on-autopushd-how-can-i-turn-it-off
unsetopt autopushd

export KEYTIMEOUT=1

fpath=(~/.zsh/completions $fpath)

# don't remember what this is?
autoload -Uz compinit && compinit
_comp_options+=(globdots)

# auto-suggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
bindkey '^ ' autosuggest-accept

# allow S-Tab for reverse autocomplete navigation
#
# https://unix.stackexchange.com/a/84869
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc

# fzf
#
# should we just use the fzf plugin?
#
#   https://github.com/robbyrussell/oh-my-zsh/issues/3003
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--ansi --inline-info --reverse --border --height 40%'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden --bind '?:toggle-preview'"
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_CTRL_T_OPTS="--exit-0 --select-1 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"
export FZF_ALT_C_OPTS="--exit-0 --select-1 --preview 'tree -C -a {} | head -200'"
#
# https://github.com/junegunn/fzf/issues/492
setopt HIST_IGNORE_ALL_DUPS

# bat
export BAT_THEME="1337"

# google
#
# https://g3doc.corp.google.com/devtools/blaze/scripts/zsh_completion/README.md?cl=head
if [[ -f /etc/bash_completion.d/g4d ]]; then
  . /etc/bash_completion.d/g4d
  . /etc/bash_completion.d/p4
fi

fpath=(
  /google/src/files/head/depot/google3/devtools/blaze/scripts/zsh_completion
  $fpath
)

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
_blaze_query_tmux() {
  tmux display-message 'Querying blaze'
  $@
}
zstyle ':completion:*:blaze-*:query' command -_blaze_query_tmux

if ! prodcertstatus -q; then
  echo 'Getting prodaccess...'
  gcert -g
fi
gcert -q && /google/data/ro/users/di/diamondm/engfortunes/fortune.sh

export G4MULTIDIFF=0
export P4DIFF='diff'
