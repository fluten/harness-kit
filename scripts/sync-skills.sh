#!/usr/bin/env bash
#
# sync-skills.sh — Sync harness-kit skills to the global Claude Code skills directory.
#
# Usage:
#   bash scripts/sync-skills.sh
#
# Run from anywhere — paths are computed relative to the script's location.
# Works on Linux, macOS, and Windows (Git Bash / WSL).
#
# What it does:
#   1. Reads every skill folder under ./skills/ in this repo
#   2. Removes any matching folder under ~/.claude/skills/ (clean install)
#   3. Copies the fresh version from the repo to ~/.claude/skills/
#   4. Reports what was synced
#
# This script is idempotent — running it multiple times has the same effect
# as running it once. Existing global skills are overwritten with the repo's
# current state, NOT merged.

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
SKILLS_DEST="$HOME/.claude/skills"

if [ ! -d "$SKILLS_SRC" ]; then
  echo "Error: skills directory not found at $SKILLS_SRC" >&2
  echo "Are you running this from inside a harness-kit checkout?" >&2
  exit 1
fi

mkdir -p "$SKILLS_DEST"

echo "Syncing harness-kit skills"
echo "  source: $SKILLS_SRC"
echo "  target: $SKILLS_DEST"
echo

count=0
for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_dir")"
  echo "  → $skill_name"
  rm -rf "$SKILLS_DEST/$skill_name"
  cp -r "$skill_dir" "$SKILLS_DEST/$skill_name"
  count=$((count + 1))
done

echo
echo "Done. $count skill(s) synced. Current ~/.claude/skills/:"
ls "$SKILLS_DEST"
