if [[ -z "$SSH_AUTH_SOCK" || ! -e "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
    export SSH_AUTH_SOCK=~/.ssh/ssh-agent.sock
    if ! pgrep -u "$USER" ssh-agent > /dev/null 2>&1; then
        # Kill old agent if it's using the same socket
        if [[ -e "$SSH_AUTH_SOCK" ]]; then
            rm "$SSH_AUTH_SOCK"
        fi
        eval "$(ssh-agent -a $SSH_AUTH_SOCK)" > /dev/null
    fi
fi
