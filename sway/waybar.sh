#!/bin/bash

if pgrep -x waybar > /dev/null; then
    killall waybar
    sleep 0.5
fi

waybar > ~/.config/waybar/waybar.log 2>&1 &

if [ $? -eq 0 ]; then
    echo "Waybar started successfully"
else
    echo "Failed to start waybar"
fi
