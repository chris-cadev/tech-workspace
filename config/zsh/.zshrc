# < oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git fzf-zsh-plugin)
source $ZSH/oh-my-zsh.sh
case $($HOME/projects/tech-workspace/init/commons/get-os-name.sh) in
  "mac")
    eval "$(/opt/homebrew/bin/brew shellenv)"
  ;;
esac
# oh-my-zsh >

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ccamacho/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# source <(fzf --zsh)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
