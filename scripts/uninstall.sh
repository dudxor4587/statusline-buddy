#!/usr/bin/env bash
set -e

BUDDY_DIR="$HOME/.statusline-buddy"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== Uninstalling statusline-buddy ==="

# 1. Remove MCP server
echo "[1/4] Removing MCP server..."
claude mcp remove statusline-buddy -s user 2>/dev/null || true

# 2. Restore original statusline
echo "[2/4] Restoring statusline..."
ORIGINAL_CMD="$BUDDY_DIR/original-statusline-cmd.txt"
if [ -f "$ORIGINAL_CMD" ] && [ -f "$SETTINGS" ]; then
  saved_cmd=$(cat "$ORIGINAL_CMD")
  node -e "
    const fs=require('fs');
    const s=JSON.parse(fs.readFileSync('$SETTINGS','utf8'));
    s.statusLine={type:'command',command:'$saved_cmd',padding:0};
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
echo "[3/4] Removing /buddy skill..."
rm -rf "$CLAUDE_DIR/skills/buddy"

# 4. Remove buddy data directory
echo "[4/4] Removing buddy data..."
rm -rf "$BUDDY_DIR"

echo ""
echo "=== Uninstall complete! ==="
