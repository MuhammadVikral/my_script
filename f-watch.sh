#!/bin/bash

dirName=$(basename "$PWD" | tr . _)
selected_name="nodemon_${dirName}"
tmux send-keys "fvm flutter run $4 $2 $3 $4 --pid-file=/tmp/tf1.pid" Enter

if ! tmux has-session -t=$selected_name 2>/dev/null; then
	tmux new-session -ds $selected_name
	tmux send-keys -t $selected_name 'npx -y nodemon --watch . -e dart -x "cat /tmp/tf1.pid | xargs kill -s USR1"' Enter
fi
