#!/bin/bash

# Ensure ADB is installed
if ! command -v adb &>/dev/null; then
  echo "ADB is not installed. Please install it first."
  exit 1
fi

# Set Firebase Analytics logging to VERBOSE
adb shell "setprop log.tag.FA VERBOSE && setprop log.tag.FA-SVC VERBOSE"

# Start logcat to capture FA and FA-SVC logs
adb logcat -v time -s FA FA-SVC
