#!/bin/bash

# Add debugging
set -x

launch_app_in_workspace() {
    local workspace=$1
    local app_command=$2
    local app_identifier=$3
    local post_wait=${4:-0.5}
    
    echo "Launching $app_identifier on workspace $workspace"
    
    swaymsg "workspace $workspace"
    sleep 1
    
    eval "$app_command"
    
    echo "Waiting for $app_identifier to appear"
    until swaymsg -t get_tree | grep -qi "$app_identifier"; do
        sleep 0.5
        echo "Still waiting for $app_identifier..."
    done
    
    echo "$app_identifier detected in window tree"
    
    sleep 2 # Give it more time to fully initialize
    
    # Approach 1: Use window ID
    local window_id=$(swaymsg -t get_tree | jq ".. | select(.name? | test(\"$app_identifier\"; \"i\")) | .id" 2>/dev/null | head -1)
    if [ ! -z "$window_id" ]; then
        echo "Moving window ID $window_id to workspace $workspace"
        swaymsg "[con_id=$window_id] move container to workspace $workspace"
    else
        echo "Could not find window ID for $app_identifier"
    fi
    
    # Approach 2: Use window criteria
    echo "Moving any window matching $app_identifier to workspace $workspace"
    swaymsg "[app_id=\"$app_identifier\"] move container to workspace $workspace"
    swaymsg "[class=\"$app_identifier\"] move container to workspace $workspace" 
    
    # For Obsidian specifically (case insensitive window class)
    if [[ "$app_identifier" == "obsidian" ]]; then
        swaymsg "[class=\"(?i)$app_identifier\"] move container to workspace $workspace"
        swaymsg "[app_id=\"(?i)$app_identifier\"] move container to workspace $workspace"
        # Try with uppercase first letter
        swaymsg "[class=\"Obsidian\"] move container to workspace $workspace"
        swaymsg "[app_id=\"Obsidian\"] move container to workspace $workspace"
    fi
}

launch_app_in_workspace 5 "swaymsg 'exec spotify'" "spotify" 1
launch_app_in_workspace 4 "swaymsg 'exec discord'" "discord" 1
#launch_app_in_workspace 4 "swaymsg 'exec telegram'" "telegram" 1
launch_app_in_workspace 3 "swaymsg 'exec obsidian'" "obsidian" 1
launch_app_in_workspace 2 "swaymsg 'exec ghostty'" "ghostty" 1
launch_app_in_workspace 1 "swaymsg 'exec zen'" "Zen" 1
