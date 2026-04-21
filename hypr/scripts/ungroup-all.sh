#!/bin/bash
# Dissolve all groups on the current workspace (like i3 layout toggle split)

WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.id')
mapfile -t WINDOWS < <(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $WORKSPACE) | .address")

for addr in "${WINDOWS[@]}"; do
    IN_GROUP=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$addr\") | .grouped | length")
    if [ "$IN_GROUP" -gt 0 ]; then
        hyprctl dispatch focuswindow "address:$addr"
        hyprctl dispatch moveoutofgroup
    fi
done
