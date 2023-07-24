#!/bin/bash

# Check if an argument (current directory) is provided
if [ $# -eq 0 ]; then
	echo "Usage: $0 <current_directory>"
	exit 1
fi

# Extract the current directory from the argument
current_directory=$1
currentFileName=$(basename $3)

# Ensure the "widgets" directory exists
widgets_directory="${current_directory}/widgets"
mkdir -p "$widgets_directory"

# Create the file inside the "widgets" directory
newFilename="$2.dart"
new_file_directory="${widgets_directory}/${newFilename}"
touch "$new_file_directory"
echo "part of '../$currentFileName';" >>"$new_file_directory"

import_line=$(grep -nE "^\s*import\s+.+" "$3" | cut -d ':' -f 1 | tail -n 1)
echo "di line berapa $import_line"
if [ -n "$import_line" ]; then
	sed -i "${import_line}a part 'widgets/${newFilename}';" "$3"
else
	sed -i "1i part 'widgets/${newFilename}';" "$3"
fi
