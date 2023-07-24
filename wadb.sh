#!/usr/bin/env fish
read ipAddr
adb kill-server
sudo adb start-server
adb tcpip 5555
adb connect $ipAddr
adb devices
