#!/bin/bash


WALLPAPER_DIR="$HOME/.config/sway"

# Function to set a random wallpaper
set_random_wallpaper() {
    # Get all jpg files in the directory
    wallpapers=( "$WALLPAPER_DIR"/*.jpg )
    
    # Check if there are any wallpapers
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No JPG wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
    
    # Select a random wallpaper
    random_index=$(( RANDOM % ${#wallpapers[@]} ))
    selected_wallpaper="${wallpapers[$random_index]}"
    
    # Set the wallpaper using swaymsg
    swaymsg output "*" bg "$selected_wallpaper" fill
    
    echo "Set wallpaper to: $selected_wallpaper"
}

# Main loop
while true; do
    set_random_wallpaper
    sleep 15m  # Sleep for 15 minutes
done
