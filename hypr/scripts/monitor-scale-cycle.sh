#!/bin/bash

MONITOR_INFO=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
ACTIVE_MONITOR=$(echo "$MONITOR_INFO" | jq -r '.name')
CURRENT_SCALE=$(echo "$MONITOR_INFO" | jq -r '.scale')
WIDTH=$(echo "$MONITOR_INFO" | jq -r '.width')
HEIGHT=$(echo "$MONITOR_INFO" | jq -r '.height')
REFRESH_RATE=$(echo "$MONITOR_INFO" | jq -r '.refreshRate')

# Cycle: 1 → 1.2 → 1.4 → 1.6 → 2 → 3 → 1
CURRENT_INT=$(awk -v s="$CURRENT_SCALE" 'BEGIN { printf "%.0f", s * 10 }')

case "$CURRENT_INT" in
10) NEW_SCALE=1.2 ;;
12) NEW_SCALE=1.4 ;;
14) NEW_SCALE=1.6 ;;
16) NEW_SCALE=2 ;;
20) NEW_SCALE=3 ;;
*)  NEW_SCALE=1 ;;
esac

hyprctl keyword monitor "$ACTIVE_MONITOR,${WIDTH}x${HEIGHT}@${REFRESH_RATE},auto,$NEW_SCALE"
notify-send -u low "󰍹    Display scaling set to ${NEW_SCALE}x"
