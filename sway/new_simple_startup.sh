#!/bin/bash

wlr-randr --output DP-2 --custom-mode 1920x1080@239.964005Hz --pos 0,0 --output eDP-1 --custom-mode 1920x1080@60.04900Hz --pos 1920,0

swaymsg workspace 5 
swaymsg exec spotify
sleep 1

swaymsg workspace 4 
swaymsg exec discord
sleep 2

swaymsg workspace 3 
swaymsg exec obsidian
sleep 2

swaymsg workspace 2 
swaymsg exec ghostty
sleep 1

swaymsg workspace 1 
swaymsg exec chromium 
