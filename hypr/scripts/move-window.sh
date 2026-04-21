#!/bin/bash
# Smart window move:
# - Inside group at edge → leaves group and moves out
# - Inside group not at edge → reorders tab
# - Outside group → moves window normally
# Usage: move-window.sh <l|r|u|d>

DIR=$1
ACTIVE=$(hyprctl activewindow -j)
ADDR=$(echo "$ACTIVE" | jq -r '.address')
GROUPED_LEN=$(echo "$ACTIVE" | jq '.grouped | length')

if [ "$GROUPED_LEN" -gt 1 ]; then
    IDX=$(echo "$ACTIVE" | jq -r ".grouped | to_entries[] | select(.value == \"$ADDR\") | .key")
    LAST=$((GROUPED_LEN - 1))

    case $DIR in
        l|u)
            if [ "$IDX" -eq 0 ]; then
                hyprctl dispatch moveoutofgroup
                hyprctl dispatch movewindow "$DIR"
            else
                hyprctl dispatch movegroupwindow b
            fi
            ;;
        r|d)
            if [ "$IDX" -eq "$LAST" ]; then
                hyprctl dispatch moveoutofgroup
                hyprctl dispatch movewindow "$DIR"
            else
                hyprctl dispatch movegroupwindow f
            fi
            ;;
    esac
else
    hyprctl dispatch movewindow "$DIR"
fi
