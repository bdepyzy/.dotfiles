#!/bin/bash
# Dissolve all groups on the current workspace (like i3 layout toggle split)

WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.id')
ACTIVE=$(hyprctl activewindow -j | jq -r '.address')
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/hypr-group-layout"
STATE_FILE="$STATE_DIR/workspace-$WORKSPACE.json"
mapfile -t WINDOWS < <(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $WORKSPACE) | .address")

for addr in "${WINDOWS[@]}"; do
    IN_GROUP=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$addr\") | .grouped | length")
    if [ "$IN_GROUP" -gt 0 ]; then
        hyprctl dispatch moveoutofgroup "address:$addr"
    fi
done

if [ -s "$STATE_FILE" ]; then
    sleep 0.1
    mapfile -t RESTORE_WINDOWS < <(jq -r '.[] | [.address, .size[0], .size[1]] | @tsv' "$STATE_FILE")

    for row in "${RESTORE_WINDOWS[@]}"; do
        IFS=$'\t' read -r addr width height <<< "$row"

        if hyprctl clients -j | jq -e ".[] | select(.address == \"$addr\" and .floating == false)" >/dev/null; then
            hyprctl dispatch resizewindowpixel "exact $width $height,address:$addr"
        fi
    done

    rm -f "$STATE_FILE"
fi

if [ -n "$ACTIVE" ]; then
    hyprctl dispatch focuswindow "address:$ACTIVE"
fi
