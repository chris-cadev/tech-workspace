# < oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git fzf-zsh-plugin)
source $ZSH/oh-my-zsh.sh
eval "$(/opt/homebrew/bin/brew shellenv)"
# oh-my-zsh >

# < fnm: Fast Node Manager
export PATH="/Users/ccamacho/Library/Application Support/fnm:$PATH"
eval "`fnm env`"
eval "$(fnm env --use-on-cd)"
# fnm >

# # < perl
PATH="/Users/ccamacho/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/ccamacho/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/ccamacho/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/ccamacho/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/ccamacho/perl5"; export PERL_MM_OPT;
# # perl >

# < pnpm: Performant NPM
export PNPM_HOME="/Users/ccamacho/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm >


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ccamacho/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


# < gvm: Go version manager
[[ -s "/Users/ccamacho/.gvm/scripts/gvm" ]] && source "/Users/ccamacho/.gvm/scripts/gvm"
# gvm >

# < pyenv
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
# pyenv >

# < iTerm2 config
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# iTerm2 config >
