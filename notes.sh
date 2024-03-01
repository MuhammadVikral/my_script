#!/bin/bash

if [[ $# -eq 1 ]]; then
	selected=$1
else
	selected='~/kerjaan/AIT/notes/'
fi

if [[ -z $selected ]]; then
	exit 0
fi

selected_name='notes'
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s $selected_name -c $selected
	exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
	tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
tmux send-keys -t $selected_name:1 "nvim" Enter
