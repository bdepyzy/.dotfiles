#!/bin/bash

# Function to launch app in background without switching workspaces
launch_app_without_switching() {
    local target_workspace=$1
    local app_command=$2
    local app_identifier=$3
    
    echo "Launching $app_identifier on workspace $target_workspace (without switching)"
    
    # Launch the application with the workspace command directly
    swaymsg "exec $app_command"
    
    # Wait for app to appear in the tree
    echo "Waiting for $app_identifier to appear"
    until swaymsg -t get_tree | grep -qi "$app_identifier"; do
        sleep 0.5
    done
    
    # Give app time to initialize
    sleep 1
    
    # Move to target workspace using window ID
    local window_id=$(swaymsg -t get_tree | jq ".. | select(.name? | test(\"$app_identifier\"; \"i\")) | .id" 2>/dev/null | head -1)
    if [ ! -z "$window_id" ]; then
        echo "Moving window ID $window_id to workspace $target_workspace"
        swaymsg "[con_id=$window_id] move container to workspace $target_workspace"
    else
        echo "Could not find window ID for $app_identifier"
    fi
    
    # Try additional methods for specific apps
    if [[ "$app_identifier" == "obsidian" ]]; then
        swaymsg "[class=\"Obsidian\"] move container to workspace $target_workspace"
        swaymsg "[app_id=\"Obsidian\"] move container to workspace $target_workspace"
    fi
    
    echo "Finished setting up $app_identifier on workspace $target_workspace"
}

# First, ensure we're on workspace 1
swaymsg "workspace 1"

# Launch Firefox first on workspace 1
swaymsg "exec firefox"
echo "Waiting for Firefox to appear"
until swaymsg -t get_tree | grep -qi "Firefox"; do
    sleep 0.5
done
echo "Firefox launched on workspace 1"

# Launch the rest of the applications without switching workspaces
launch_app_without_switching 5 "spotify" "spotify"
launch_app_without_switching 4 "discord" "discord"
launch_app_without_switching 3 "obsidian" "obsidian"
launch_app_without_switching 2 "ghostty" "ghostty"

echo "All applications launched successfully"
