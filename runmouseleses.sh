#!/bin/bash

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s mouseless -c ~/
	exit 0
fi
if ! tmux has-session -t=mouseless 2>/dev/null; then
	tmux new-session -ds mouseless -c ~/
fi

tmux send-keys -t mouseless "sudo mouseless --config ~/.config/mouseless/config.yaml" Enter
tmux send-keys -t mouseless "021095" Enter
