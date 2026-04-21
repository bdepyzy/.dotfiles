#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"

# Copy configs into dotfiles
cp -r ~/.config/hypr        "$DOTFILES/hypr/hypr"
cp -r ~/.config/nvim        "$DOTFILES/nvim/nvim"
cp -r ~/.config/fastfetch   "$DOTFILES/fastfetch/fastfetch"
cp --remove-destination ~/.zshrc    "$DOTFILES/.zshrc.omarchy"
cp --remove-destination ~/.tmux.conf "$DOTFILES/.tmux.conf"

# Commit and push
cd "$DOTFILES"
git add -A
git diff --cached --quiet || git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push

# Remove copies (git has them, no need to keep locally)
rm -rf "$DOTFILES/hypr/hypr"
rm -rf "$DOTFILES/nvim/nvim"
rm -rf "$DOTFILES/fastfetch/fastfetch"

echo "Done."
