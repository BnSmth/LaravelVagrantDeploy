# Enable aliases to be sudo’ed
alias sudo='sudo '

alias ~='cd /vagrant'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; 
then # GNU `ls`
        colorflag="--color"
else # OSX `ls`
        colorflag="-G"
fi

alias ls="command ls ${colorflag}"
alias l="ls -lF ${colorflag}" # all files, in long format
alias la="ls -laF ${colorflag}" # all files inc dotfiles, in long format
alias lsd='ls -lF ${colorflag} | grep "^d"' # only directories

# Quicker navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# ARTISAN
alias artisan="php artisan"
alias seed="php artisan db:seed"
alias rollback="artisan migrate:rollback"
alias migrate="artisan migrate"
alias refresh="artisan migrate:refresh"
alias tinker="artisan tinker"

#GIT
alias gs="git status"
alias gaa="git add ."
alias ga="git add"
alias gc="git commit -m"
alias gl="git log"
alias glo="git log --oneline"
alias gp="git push"
alias gcl='git clone'