#!/bin/bash
# Group all windows on the current workspace into a tab group (like i3 layout tabbed)

WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.id')
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/hypr-group-layout"
STATE_FILE="$STATE_DIR/workspace-$WORKSPACE.json"
mapfile -t WINDOWS < <(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $WORKSPACE) | .address")

COUNT=${#WINDOWS[@]}
[ "$COUNT" -lt 2 ] && exit 0

GROUPED_COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WORKSPACE and (.grouped | length) > 0)] | length")

if [ "$GROUPED_COUNT" -eq 0 ]; then
    mkdir -p "$STATE_DIR"
    hyprctl clients -j | jq \
        ".[] | select(.workspace.id == $WORKSPACE and .floating == false) | {address, at, size}" | \
        jq -s 'sort_by(.at[1], .at[0])' > "$STATE_FILE"
fi

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
