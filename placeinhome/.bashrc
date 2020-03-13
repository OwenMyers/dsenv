
set -o vi
alias nvim='/root/neovim/build/bin/nvim -c UpdateRemotePlugins'

############# PATH ################
export PATH=$PATH:/home/om/.local/bin

############# Docker ##############
alias dr='docker rm'
alias ds='docker stop'
alias dl='docker log'
alias dps='docker ps -a'

############# Git ##############
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gc='git commit'
alias gd='git diff'
alias ga='git add'
alias gpl='git log --graph --simplify-by-decoration --all'

g () { git grep -En "$@" -- ':!*.min.css' ':!*.min.js'; }
