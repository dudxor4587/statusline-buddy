#!/usr/bin/env bash
set -e

BUDDY_DIR="$HOME/.claude-buddy"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== statusline-buddy 제거 ==="

# 1. MCP 서버 제거
echo "[1/3] MCP 서버 제거..."
claude mcp remove buddy-statusline 2>/dev/null || true

# 2. statusline 원복
echo "[2/3] statusline 원복..."
ORIGINAL="$BUDDY_DIR/original-statusline-command.sh"
if [ -f "$ORIGINAL" ] && [ -f "$SETTINGS" ]; then
  tmp=$(mktemp)
  jq --arg cmd "bash $ORIGINAL" '.statusLine.command = $cmd' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
  echo "  기존 statusline으로 복원됨"
elif [ -f "$SETTINGS" ]; then
  tmp=$(mktemp)
  jq 'del(.statusLine)' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
  echo "  statusline 설정 제거됨"
fi

# 3. 스킬 파일 제거
echo "[3/3] /buddy 스킬 제거..."
rm -rf "$CLAUDE_DIR/skills/buddy"

echo ""
echo "=== 제거 완료! ==="
echo "프로필 데이터는 $BUDDY_DIR/profile.json에 남아있습니다."
echo "완전히 삭제하려면: rm -rf $BUDDY_DIR"
