#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"
HOSTNAME=$(hostname)

# Copy configs into dotfiles (common)
cp -r ~/.config/nvim        "$DOTFILES/nvim" 2>/dev/null || true
cp -r ~/.config/fastfetch   "$DOTFILES/fastfetch" 2>/dev/null || true
cp -r ~/.config/tmux        "$DOTFILES/tmux" 2>/dev/null || true

# Machine-specific configs
if [ "$HOSTNAME" = "carbon" ]; then
    cp -r ~/.config/hypr    "$DOTFILES/hypr"
    cp -r ~/.config/waybar  "$DOTFILES/waybar"
    cp ~/.zshrc             "$DOTFILES/.zshrc.omarchy"
    cp ~/.config/tmux/tmux.conf "$DOTFILES/.tmux.conf.omarchy"
elif [ "$HOSTNAME" = "do" ] || [ "$HOSTNAME" = "ubuntui3" ]; then
    cp -r ~/.config/kitty   "$DOTFILES/kitty" 2>/dev/null || true
    cp -r ~/.config/ghostty "$DOTFILES/ghostty" 2>/dev/null || true
    cp -r ~/.config/i3      "$DOTFILES/i3" 2>/dev/null || true
    cp -r ~/.config/i3blocks "$DOTFILES/i3blocks" 2>/dev/null || true
    cp -r ~/.config/waybar  "$DOTFILES/waybar" 2>/dev/null || true
    cp ~/.zshrc             "$DOTFILES/.zshrc.ubuntui3"
    cp ~/.config/tmux/tmux.conf "$DOTFILES/.tmux.conf.ubuntui3" 2>/dev/null || true
fi

# Commit and push
cd "$DOTFILES"
git add -A
git diff --cached --quiet || git commit -m "sync: $HOSTNAME $(date '+%Y-%m-%d %H:%M')"
git push

# Remove copies (git has them, no need to keep locally)
rm -rf "$DOTFILES/hypr" "$DOTFILES/waybar" "$DOTFILES/nvim" "$DOTFILES/tmux" "$DOTFILES/fastfetch"
rm -rf "$DOTFILES/kitty" "$DOTFILES/ghostty" "$DOTFILES/i3" "$DOTFILES/i3blocks" "$DOTFILES/waybar"
rm -f "$DOTFILES/.zshrc.omarchy" "$DOTFILES/.zshrc.ubuntui3"
rm -f "$DOTFILES/.tmux.conf.omarchy" "$DOTFILES/.tmux.conf.ubuntui3"

echo "Done."
