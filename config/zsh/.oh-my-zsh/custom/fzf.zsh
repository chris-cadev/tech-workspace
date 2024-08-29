HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
case $(~/projects/tech-workspace/init/commons/get-os-name.sh) in
    "mac")
        source <(fzf --zsh)
    ;;
    "debian" | "wsl-debian")
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    ;;
esac