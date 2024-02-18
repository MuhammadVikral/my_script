#!/bin/bash

if ! tmux has-session -t=mouseless 2>/dev/null; then
	tmux new-session -ds mouseless -c ~/
	tmux send-keys -t mouseless "sudo mouseless --config ~/.config/mouseless/config.yaml" Enter
	tmux send-keys -t mouseless "021095" Enter
else
	tmux kill-session -t mouseless
fi
