#!/bin/bash

session="drata-development"

tmux has-session -t $session 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $session

    window=0
    tmux rename-window -t $session:$window 'commands'

    window=1
    tmux new-window -t $session:$window -n 'logs'
    tmux send-keys -t $session:$window 'cd ~/projects/drata/api' C-m
    tmux send-keys -t $session:$window 'dev && yarn start' C-m
    tmux split-window -v
    tmux send-keys -t $session:$window 'cd ~/projects/drata/web' C-m
    tmux send-keys -t $session:$window 'yarn && yarn start' C-m
    tmux resize-pane -y 1
fi

# Attach to the tmux session
tmux attach-session -t $session
