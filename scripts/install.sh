#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUDDY_DIR="$HOME/.claude-buddy"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== statusline-buddy 설치 ==="

# 1. 의존성 설치
echo "[1/4] 의존성 설치..."
cd "$PROJECT_DIR" && npm install --silent

# 2. MCP 서버 등록
echo "[2/4] MCP 서버 등록..."
claude mcp remove buddy-statusline 2>/dev/null || true
claude mcp add buddy-statusline -- npx tsx "$PROJECT_DIR/src/index.ts"

# 3. 기존 statusline 백업 + buddy wrapper 설치
echo "[3/4] statusline 설정..."
mkdir -p "$BUDDY_DIR"

# 기존 statusline command 백업
if [ -f "$SETTINGS" ]; then
  existing_cmd=$(jq -r '.statusLine.command // ""' "$SETTINGS" 2>/dev/null)
  if [ -n "$existing_cmd" ] && [[ "$existing_cmd" != *"buddy-statusline.sh"* ]]; then
    # 기존 커맨드가 인라인이면 스크립트로 저장
    if [ -f "$existing_cmd" ] || [[ "$existing_cmd" == *".sh"* ]]; then
      cp "$existing_cmd" "$BUDDY_DIR/original-statusline-command.sh" 2>/dev/null || true
    else
      echo "#!/usr/bin/env bash" > "$BUDDY_DIR/original-statusline-command.sh"
      echo "$existing_cmd" >> "$BUDDY_DIR/original-statusline-command.sh"
    fi
    chmod +x "$BUDDY_DIR/original-statusline-command.sh"
    echo "  기존 statusline 백업 완료"
  fi
fi

# buddy wrapper를 statusline으로 설정
WRAPPER="$PROJECT_DIR/statusline/buddy-statusline.sh"
chmod +x "$WRAPPER"

# settings.json 업데이트
if [ -f "$SETTINGS" ]; then
  tmp=$(mktemp)
  jq --arg cmd "bash $WRAPPER" '.statusLine = {"type": "command", "command": $cmd, "padding": 0}' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
else
  mkdir -p "$CLAUDE_DIR"
  echo "{\"statusLine\":{\"type\":\"command\",\"command\":\"bash $WRAPPER\",\"padding\":0}}" | jq . > "$SETTINGS"
fi

# 4. 스킬 파일 복사
echo "[4/4] /buddy 스킬 등록..."
mkdir -p "$CLAUDE_DIR/skills/buddy"
cp "$PROJECT_DIR/skill/SKILL.md" "$CLAUDE_DIR/skills/buddy/SKILL.md"

echo ""
echo "=== 설치 완료! ==="
echo "Claude Code를 재시작하면 적용됩니다."
echo "  /buddy       — 버디 보기"
echo "  /buddy art   — ASCII 아트 변경"
echo "  /buddy say   — 말풍선"
echo "  /buddy rename — 이름 변경"
