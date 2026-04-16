#!/usr/bin/env bash
set -e

BUDDY_DIR="$HOME/.statusline-buddy"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== Uninstalling statusline-buddy ==="

# 1. Remove MCP server
echo "[1/3] Removing MCP server..."
claude mcp remove statusline-buddy -s user 2>/dev/null || true

# 2. Restore original statusline
echo "[2/3] Restoring statusline..."
ORIGINAL="$BUDDY_DIR/original-statusline-command.sh"
if [ -f "$ORIGINAL" ] && [ -f "$SETTINGS" ]; then
  node -e "
    const fs=require('fs');
    const s=JSON.parse(fs.readFileSync('$SETTINGS','utf8'));
    s.statusLine.command='bash $ORIGINAL';
    fs.writeFileSync('$SETTINGS',JSON.stringify(s,null,2));
  "
  echo "  Original statusline restored"
elif [ -f "$SETTINGS" ]; then
  node -e "
    const fs=require('fs');
    const s=JSON.parse(fs.readFileSync('$SETTINGS','utf8'));
    delete s.statusLine;
    fs.writeFileSync('$SETTINGS',JSON.stringify(s,null,2));
  "
  echo "  Statusline config removed"
fi

# 3. Remove skill file
echo "[3/3] Removing /buddy skill..."
rm -rf "$CLAUDE_DIR/skills/buddy"

echo ""
echo "=== Uninstall complete! ==="
echo "Profile data remains at $BUDDY_DIR/profile.json"
echo "To delete everything: rm -rf $BUDDY_DIR"
