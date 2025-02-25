# < oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
case $($HOME/projects/tech-workspace/init/commons/get-os-name.sh) in
    "mac")
        eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
esac
# oh-my-zsh >

autoload -Uz compinit
compinit
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
