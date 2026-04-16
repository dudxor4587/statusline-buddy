#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUDDY_DIR="$HOME/.statusline-buddy"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== Installing statusline-buddy ==="

# 1. Install dependencies
echo "[1/4] Installing dependencies..."
cd "$PROJECT_DIR" && npm install --silent

# 2. Register MCP server
echo "[2/4] Registering MCP server..."
claude mcp remove statusline-buddy -s user 2>/dev/null || true
claude mcp add statusline-buddy -s user -- npx tsx "$PROJECT_DIR/src/index.ts"

# 3. Statusline setup
echo "[3/4] Setting up statusline..."
mkdir -p "$BUDDY_DIR"

# Detect existing statusline
existing_cmd=""
if [ -f "$SETTINGS" ]; then
  existing_cmd=$(node -p "try{JSON.parse(require('fs').readFileSync('$SETTINGS','utf8')).statusLine?.command||''}catch(e){''}" 2>/dev/null)
  [[ "$existing_cmd" == *"statusline-buddy.sh"* ]] && existing_cmd=""
fi

echo ""
echo "Choose your statusline setup:"
echo "  1) Buddy only"
echo "  2) Buddy + bundled statusline (folder, branch, model, context)"
if [ -n "$existing_cmd" ]; then
  echo "  3) Buddy + your existing statusline"
fi
echo ""

read -r -p "Choose [1/2$([ -n "$existing_cmd" ] && echo '/3')]: " choice

case "$choice" in
  2)
    cp "$PROJECT_DIR/statusline/default-statusline.sh" "$BUDDY_DIR/original-statusline-command.sh"
    chmod +x "$BUDDY_DIR/original-statusline-command.sh"
    echo "  Bundled statusline will be used"
    ;;
  3)
    if [ -n "$existing_cmd" ]; then
      echo "#!/usr/bin/env bash" > "$BUDDY_DIR/original-statusline-command.sh"
      echo "input=\$(cat)" >> "$BUDDY_DIR/original-statusline-command.sh"
      echo "echo \"\$input\" | $existing_cmd" >> "$BUDDY_DIR/original-statusline-command.sh"
      chmod +x "$BUDDY_DIR/original-statusline-command.sh"
      echo "  Existing statusline backed up"
    else
      echo "  No existing statusline found, using buddy only"
    fi
    ;;
  *)
    rm -f "$BUDDY_DIR/original-statusline-command.sh"
    echo "  Buddy only"
    ;;
esac

WRAPPER="$PROJECT_DIR/statusline/statusline-buddy.sh"
chmod +x "$WRAPPER"

# Update settings.json
if [ -f "$SETTINGS" ]; then
  node -e "
    const fs=require('fs');
    const s=JSON.parse(fs.readFileSync('$SETTINGS','utf8'));
    s.statusLine={type:'command',command:'bash $WRAPPER',padding:0};
    fs.writeFileSync('$SETTINGS',JSON.stringify(s,null,2));
  "
else
  mkdir -p "$CLAUDE_DIR"
  node -e "
    const fs=require('fs');
    const s={statusLine:{type:'command',command:'bash $WRAPPER',padding:0}};
    fs.writeFileSync('$SETTINGS',JSON.stringify(s,null,2));
  "
fi

# 4. Install skill file
echo "[4/4] Installing /buddy skill..."
mkdir -p "$CLAUDE_DIR/skills/buddy"
cp "$PROJECT_DIR/skill/SKILL.md" "$CLAUDE_DIR/skills/buddy/SKILL.md"

echo ""
echo "=== Installation complete! ==="
echo "Restart Claude Code to apply."
echo "/buddy help  — show available commands"
