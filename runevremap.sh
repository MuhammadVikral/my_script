#!/bin/bash

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s evremap -c ~/
	exit 0
fi
if ! tmux has-session -t=evremap 2>/dev/null; then
	tmux new-session -ds evremap -c ~/
fi

tmux switch-client -t evremap
tmux send-keys -t evremap "sudo evremap remap evremap_config.toml" Enter
tmux send-keys -t evremap "021095" Enter

# tmux send-keys "sudo evremap remap evremap_config.toml" Enter
