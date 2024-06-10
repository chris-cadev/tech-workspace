#/bin/bash -e

# unless fnm is already installed
if ! command -v fnm >/dev/null 2>&1; then
    curl -fsSL https://fnm.vercel.app/install | bash
    fnm completions --shell zsh
    eval "$(fnm env --use-on-cd)"
fi

fnm install --lts
fnm default lts-latest
fnm use lts-latest