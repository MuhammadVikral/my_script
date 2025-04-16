#!/bin/bash

set -e # Exit immediately if any command fails

# Define credentials file
CREDENTIALS_FILE="$HOME/git-credentials-account.txt"

# Check if the credentials file exists
if [[ ! -f "$CREDENTIALS_FILE" ]]; then
  echo "❌ Error: $CREDENTIALS_FILE not found!"
  exit 1
fi

# Load credentials from file
source "$CREDENTIALS_FILE"

# Function to set Git credentials
set_git_credentials() {
  local account=$1
  local url=${!account}

  if [[ -z "$url" ]]; then
    echo "❌ Error: Account '$account' not found in $CREDENTIALS_FILE"
    exit 1
  fi

  echo "🔄 Switching Git credentials to '$account'..."

  # Set Git credentials
  git config --global credential.helper store
  echo "$url" >~/.git-credentials
  git config --global user.name "$account"
  git config --global user.email "$(git config --global user.email)"

  echo "✅ Git credentials updated for '$account'"
}

# Check input
if [[ -z "$1" ]]; then
  echo "Usage: $0 [work|personal]"
  exit 1
fi

set_git_credentials "$1"
