mkdir -p $HOME/.bin

export PATH=$HOME/.bin:/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.fzf/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/lib/google-golang/bin
export PATH=$PATH:$HOME/go/bin

source $HOME/.cargo/env
