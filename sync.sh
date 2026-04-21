#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"

# Copy configs into dotfiles
mkdir -p "$DOTFILES/hypr" "$DOTFILES/nvim" "$DOTFILES/fastfetch" "$DOTFILES/tmux"
cp -r ~/.config/hypr        "$DOTFILES/hypr/hypr"
cp -r ~/.config/nvim        "$DOTFILES/nvim/nvim"
cp -r ~/.config/fastfetch   "$DOTFILES/fastfetch/fastfetch"
cp -r ~/.config/tmux        "$DOTFILES/tmux/tmux"
cp ~/.zshrc                 "$DOTFILES/.zshrc.omarchy"

# Commit and push
cd "$DOTFILES"
git add -A
git diff --cached --quiet || git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push

# Remove copies (git has them, no need to keep locally)
rm -rf "$DOTFILES/hypr/hypr"
rm -rf "$DOTFILES/nvim/nvim"
rm -rf "$DOTFILES/tmux/tmux"
rm -rf "$DOTFILES/fastfetch/fastfetch"

echo "Done."
