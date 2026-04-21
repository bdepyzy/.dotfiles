export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-syntax-highlighting
  #zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
fastfetch


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/usr/local/go/bin


[[ ! -r '/home/do/.opam/opam-init/init.zsh' ]] || source '/home/do/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

export PATH=$HOME/.local/bin:$PATH
alias up="docker compose up --build"
alias down="docker compose down -v"
export GOPRIVATE=gitlab.dyninno.net
alias g++='/usr/bin/g++ -std=c++17'
alias c++='/usr/bin/c++ -std=c++17'
PATH=$PATH:$HOME/go/bin
export PATH=$PATH:/home/do/Downloads/PATH/genymotion

export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

export PNPM_HOME="/home/do/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

alias clip='xclip -selection clipboard'
alias todo='nvim ~/mind/Zettelkasten/LIST.md'

alias ssh='TERM=xterm-256color ssh'

# opencode
export PATH=/home/do/.opencode/bin:$PATH

[ -s "/home/do/.bun/_bun" ] && source "/home/do/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
source /opt/ros/humble/setup.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/do/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/do/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/do/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/do/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

#setxkbmap -model pc104 -layout us,ru -option "grp:alt_shift_toggle,caps:escape"
alias copy="xclip -selection clipboard"
alias codex="nvm use node && codex"
alias dev="docker compose -f docker-compose.yaml -f docker-compose.dev.yaml"
alias tat="tmux attach-session -t"
alias trt="tmux kill-session -t"

gacp(){ git add . && git commit -m "${1:?commit message required}" && git push; }
