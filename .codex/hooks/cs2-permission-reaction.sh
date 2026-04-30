#!/usr/bin/env bash
set -euo pipefail

# Drain stdin so Codex can send the hook payload without blocking.
cat >/dev/null

export CS2_REACTION_SOUND="/home/bdepyzy/.local/share/cs2-reactions/sounds__vo__agents__jungle_fem__aff1_cheer_08.wav"
"$HOME/.local/bin/cs2-reaction" --notify "Codex permission" "Approval requested"
