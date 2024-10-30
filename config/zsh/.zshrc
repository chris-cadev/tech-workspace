# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/ccamacho/completions:"* ]]; then export FPATH="/Users/ccamacho/completions:$FPATH"; fi
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

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ccamacho/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# fnm
FNM_PATH="/Users/ccamacho/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/ccamacho/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

# fnm
FNM_PATH="/Users/ccamacho/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/ccamacho/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"
. "/Users/ccamacho/.deno/env"
# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit
# bun completions
[ -s "/Users/ccamacho/.bun/_bun" ] && source "/Users/ccamacho/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
