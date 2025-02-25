export PATH="/home/cavila/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# mac
# FNM_PATH="$HOME/Library/Application Support/fnm"
# if [ -d "$FNM_PATH" ]; then
#     export PATH="$HOME/Library/Application Support/fnm:$PATH"
#     eval "`fnm env`"
# fi
