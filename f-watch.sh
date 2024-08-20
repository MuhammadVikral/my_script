#grep list of app in flutter app
if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(find app/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi
if [[ -z $selected ]]; then
  exit 0
fi

dirName=$(basename "$PWD" | tr . _)
selected_app=$(basename "$selected" | tr . _)
selected_name="flutter_runner_${dirName}_${selected_app}"
tmux_running=$(pgrep tmux)

#create new session dedicated for running the flutter app
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s $selected_name -c $selected
  exit 0
fi

if ! tmux has-session -t=$selected_name 2>/dev/null; then
  tmux new-session -ds $selected_name -c $selected
fi

#create new window dedicated for running the nodemon
if ! tmux list-windows -t $selected_name -F '#{window_name}' | grep -q '^nodemon$'; then
  # Create a new window named "nodemon"
  tmux new-window -t $selected_name -n "nodemon"
fi

#run the flutter run and nodemon watch and then switch to runner client
# tmux send-keys -t $selected_name:1 "fvm flutter run $4 $2 $3 $4 --pid-file=/tmp/tf1.pid --target lib/main.dart --flavor dev" Enter
tmux send-keys -t $selected_name:1 "fvm flutter run $4 $2 $3 $4 --pid-file=/tmp/tf1.pid --flavor dev" Enter
tmux send-keys -t $selected_name:nodemon 'npx -y nodemon --watch . -e dart -x "cat /tmp/tf1.pid | xargs kill -s USR1"' Enter
tmux switch-client -t "$selected_name:1"
