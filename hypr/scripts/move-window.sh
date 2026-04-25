#!/bin/bash
# Smart window move:
# - Inside group at edge → leaves group and moves out
# - Inside group not at edge → reorders tab
# - Outside group → moves window normally
# Usage: move-window.sh <l|r|u|d>

DIR=$1
ACTIVE=$(hyprctl activewindow -j)
ADDR=$(echo "$ACTIVE" | jq -r '.address')
WORKSPACE=$(echo "$ACTIVE" | jq -r '.workspace.id')
GROUPED_LEN=$(echo "$ACTIVE" | jq '.grouped | length')
LAYOUT=$(mktemp)

hyprctl clients -j | jq \
    ".[] | select(.workspace.id == $WORKSPACE and .floating == false) | {address, at, size}" | \
    jq -s 'sort_by(.at[1], .at[0])' > "$LAYOUT"

restore_layout() {
    sleep 0.1
    mapfile -t RESTORE_WINDOWS < <(jq -r '.[] | [.address, .size[0], .size[1]] | @tsv' "$LAYOUT")

    for row in "${RESTORE_WINDOWS[@]}"; do
        IFS=$'\t' read -r addr width height <<< "$row"

        if hyprctl clients -j | jq -e ".[] | select(.address == \"$addr\" and .workspace.id == $WORKSPACE and .floating == false)" >/dev/null; then
            hyprctl dispatch resizewindowpixel "exact $width $height,address:$addr"
        fi
    done

    rm -f "$LAYOUT"
    hyprctl dispatch focuswindow "address:$ADDR"
}

if [ "$GROUPED_LEN" -gt 1 ]; then
    IDX=$(echo "$ACTIVE" | jq -r ".grouped | to_entries[] | select(.value == \"$ADDR\") | .key")
    LAST=$((GROUPED_LEN - 1))

    case $DIR in
        l|u)
            if [ "$IDX" -eq 0 ]; then
                hyprctl dispatch moveoutofgroup
                hyprctl dispatch movewindow "$DIR"
                restore_layout
            else
                hyprctl dispatch movegroupwindow b
                rm -f "$LAYOUT"
            fi
            ;;
        r|d)
            if [ "$IDX" -eq "$LAST" ]; then
                hyprctl dispatch moveoutofgroup
                hyprctl dispatch movewindow "$DIR"
                restore_layout
            else
                hyprctl dispatch movegroupwindow f
                rm -f "$LAYOUT"
            fi
            ;;
    esac
else
    hyprctl dispatch movewindow "$DIR"
    restore_layout
fi
