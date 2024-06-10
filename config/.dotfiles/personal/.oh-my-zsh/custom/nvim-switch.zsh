# inspired by Elijah Manor: https://www.youtube.com/watch?v=LkHjJlSgKZY
# and DevOps Toolbox: https://www.youtube.com/watch?v=oLpGahrsSGQ

alias nvim-code="NVIM_APPNAME=CoceNVIM nvim"
alias nvim-write="NVIM_APPNAME=WriteNVIM nvim"
alias nvim-deprecated="NVIM_APPNAME=nvim.deprecated nvim"

alias nvc="nvim-code"
alias nvw="nvim-write"
alias nv="nvim-deprecated"

function nvims() {
  items=$(ls -d $HOME/.config/*/ | grep -iE ".+vim.+" | xargs basename)

  config=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config: " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config="nvim.deprecated"
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"
