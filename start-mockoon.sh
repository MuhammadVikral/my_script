#!/bin/bash

# Use the current directory where the script is run
MOCKOON_DIR=$(pwd)

# Use fzf to select a JSON file from the current directory
SELECTED_FILE=$(find "$MOCKOON_DIR" -type f -name "*.json" | fzf)

# Check if a file was selected
if [ -z "$SELECTED_FILE" ]; then
  echo "No file selected. Exiting..."
  exit 1
fi

# Inform which environment is selected
echo "Starting Mockoon with environment: $SELECTED_FILE"

# Optional: Use nodemon to restart if the JSON file changes, also in a new pane
tmux split-window -h "nodemon --watch \"$SELECTED_FILE\" --exec \"mockoon-cli start --data '$SELECTED_FILE' --port 3000\""

# Split tmux pane and run Mockoon CLI in the new pane
# mockoon-cli start --data $SELECTED_FILE --port 3000
