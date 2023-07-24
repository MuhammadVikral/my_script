#!/usr/bin/env fish

sudo libinput list-devices | grep -E 'event|Device'
read -P "Enter event number: " event
sudo evtest --grab /dev/input/event$event
