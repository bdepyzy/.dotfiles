#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"
HOSTNAME=$(hostname)

# Copy configs into dotfiles (common)
cp -r ~/.config/nvim        "$DOTFILES/nvim" 2>/dev/null || true
cp -r ~/.config/fastfetch   "$DOTFILES/fastfetch" 2>/dev/null || true
cp -r ~/.config/tmux        "$DOTFILES/tmux" 2>/dev/null || true
mkdir -p "$DOTFILES/.local/bin" "$DOTFILES/.local/share" "$DOTFILES/.config/opencode" "$DOTFILES/.codex"
cp ~/.local/bin/cs2-reaction "$DOTFILES/.local/bin/cs2-reaction" 2>/dev/null || true
cp -r ~/.local/share/cs2-reactions "$DOTFILES/.local/share/cs2-reactions" 2>/dev/null || true
cp ~/.config/opencode/opencode.json "$DOTFILES/.config/opencode/opencode.json" 2>/dev/null || true
cp ~/.config/opencode/package.json "$DOTFILES/.config/opencode/package.json" 2>/dev/null || true
cp -r ~/.config/opencode/plugins "$DOTFILES/.config/opencode/plugins" 2>/dev/null || true
cp ~/.codex/config.toml "$DOTFILES/.codex/config.toml" 2>/dev/null || true
cp -r ~/.codex/hooks "$DOTFILES/.codex/hooks" 2>/dev/null || true

# Machine-specific configs
if [ "$HOSTNAME" = "carbon" ]; then
    cp -r ~/.config/hypr    "$DOTFILES/hypr"
    cp -r ~/.config/waybar  "$DOTFILES/waybar"
    cp -r ~/.config/ghostty "$DOTFILES/ghostty"
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

echo "Done."
