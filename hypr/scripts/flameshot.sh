#!/bin/bash
FS_BEFORE=$(hyprctl activewindow -j | grep -o '"fullscreen":[0-9]*' | grep -o '[0-9]*$')

flameshot gui --clipboard --accept-on-select

sleep 0.3

FS_AFTER=$(hyprctl activewindow -j | grep -o '"fullscreen":[0-9]*' | grep -o '[0-9]*$')
if [ "${FS_BEFORE:-0}" = "0" ] && [ "${FS_AFTER:-0}" != "0" ]; then
    hyprctl dispatch fullscreen
fi
