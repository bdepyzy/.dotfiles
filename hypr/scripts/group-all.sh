#!/bin/bash
# Group all windows on the current workspace into a tab group (like i3 layout tabbed)

WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.id')
mapfile -t WINDOWS < <(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $WORKSPACE) | .address")

COUNT=${#WINDOWS[@]}
[ "$COUNT" -lt 2 ] && exit 0

# Focus first window; dissolve any existing group then create a fresh one
hyprctl dispatch focuswindow "address:${WINDOWS[0]}"
IN_GROUP=$(hyprctl activewindow -j | jq '.grouped | length')
[ "$IN_GROUP" -gt 0 ] && hyprctl dispatch togglegroup
hyprctl dispatch togglegroup

# Pull each remaining window into the group from all directions
for ((i=1; i<COUNT; i++)); do
    hyprctl dispatch focuswindow "address:${WINDOWS[$i]}"
    for dir in l r u d; do
        hyprctl dispatch moveintogroup "$dir"
    done
done
