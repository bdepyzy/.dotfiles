#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"

# Copy configs into dotfiles
cp -r ~/.config/hypr        "$DOTFILES/hypr"
cp -r ~/.config/nvim        "$DOTFILES/nvim"
cp -r ~/.config/fastfetch   "$DOTFILES/fastfetch"
cp -r ~/.config/tmux        "$DOTFILES/tmux"
cp ~/.zshrc                 "$DOTFILES/.zshrc.omarchy"

# Keep .tmux.conf.omarchy permanently if on carbon
if [ "$(hostname)" = "carbon" ]; then
    cp ~/.config/tmux/tmux.conf "$DOTFILES/.tmux.conf.omarchy"
fi

# Commit and push
cd "$DOTFILES"
git add -A
git diff --cached --quiet || git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
git push

# Remove copies (git has them, no need to keep locally)
rm -rf "$DOTFILES/hypr" "$DOTFILES/nvim" "$DOTFILES/tmux" "$DOTFILES/fastfetch" "$DOTFILES/.zshrc.omarchy"

echo "Done."
