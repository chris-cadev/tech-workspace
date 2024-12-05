OS="$(os-name)"
if [[ $OS == "mac" ]]; then
  export PNPM_HOME="~/Library/pnpm"
elif [[ $OS == "ubuntu" ]]
  export PNPM_HOME="~/.pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac