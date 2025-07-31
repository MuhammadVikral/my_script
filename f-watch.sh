#!/bin/bash

# Select app directory
if [[ $# -ge 1 ]]; then
  selected=$1
else
  selected=$(find app/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

# Ask for flavor if not passed
if [[ $# -ge 2 ]]; then
  flavor=$2
else
  echo "Enter flavor (default: dev): "
  read -r flavor
  flavor=${flavor:-dev}
fi

if [[ -z $selected ]]; then
  echo "No app selected. Exiting."
  exit 0
fi

dirName=$(basename "$PWD" | tr . _)
selected_app=$(basename "$selected" | tr . _)
selected_name="flutter_runner_${dirName}_${selected_app}"
tmux_running=$(pgrep tmux)

# Create new session dedicated for running the Flutter app
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s $selected_name -c $selected
  exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
  tmux new-session -ds $selected_name -c $selected
fi

# Create "nodemon" window if missing
if ! tmux list-windows -t $selected_name -F '#{window_name}' | grep -q '^nodemon$'; then
  tmux new-window -t $selected_name -n "nodemon"
fi

# Run flutter and nodemon
tmux send-keys -t $selected_name:1 "fvm flutter run --pid-file=/tmp/tf1.pid --target lib/main.dart --flavor $flavor" Enter
tmux send-keys -t $selected_name:nodemon 'npx -y nodemon --watch . -e dart -x "cat /tmp/tf1.pid | xargs kill -s USR1"' Enter
tmux switch-client -t "$selected_name:1"
