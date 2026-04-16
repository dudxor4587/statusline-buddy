#!/usr/bin/env bash
# Buddy statusline wrapper — renders buddy art, then runs original statusline

input=$(cat)

reset=$'\033[0m'
dim=$'\033[90m'

# ─── Buddy from profile.json ─────────────────────────────────────────────────
PROFILE="$HOME/.claude-buddy/profile.json"
DEFAULT_ART='   ┌─────────┐
   │  •   •  │
   │    ◡    │
   └────┬────┘
   ┌────┴────┐
   │         │
   │  Buddy  │
   │         │
   └─┬─────┬─┘
     │     │
    ─┘     └─'

if [ -f "$PROFILE" ]; then
  buddy_name=$(jq -r '.name // "Buddy"' "$PROFILE")
  art=$(jq -r '.art // ""' "$PROFILE")
  speech=$(jq -r '.speech // ""' "$PROFILE")
else
  buddy_name="Buddy"
  art=""
  speech=""
fi

[ -z "$art" ] && art="$DEFAULT_ART"

# Split art into lines, find max visual width
buddy_lines=()
max_w=0
while IFS= read -r line; do
  buddy_lines+=("$line")
  stripped=$(printf '%s' "$line" | sed 's/[[:space:]]*$//')
  w=${#stripped}
  (( w > max_w )) && max_w=$w
done <<< "$art"

for ((i=0; i<${#buddy_lines[@]}; i++)); do
  printf -v buddy_lines[$i] "%-${max_w}s" "${buddy_lines[$i]}"
done

# Buddy art + speech at middle
count=${#buddy_lines[@]}
idx_speech=$(( count / 2 ))
for ((i=0; i<count; i++)); do
  suffix=""
  if [ "$i" -eq "$idx_speech" ] && [ -n "$speech" ]; then
    suffix="  ${dim}💬 ${speech}${reset}"
  fi
  printf "%b%b\n" "${dim}${buddy_lines[$i]}${reset}" "$suffix"
done

# Separator (centered name, width matches art)
byte_len=$(printf '%s' "$buddy_name" | wc -c | tr -d ' ')
char_len=${#buddy_name}
wide_count=$(( (byte_len - char_len) / 2 ))
name_display_w=$(( char_len + wide_count ))

white=$'\033[37m'
sep_width=$max_w
left_len=$(( (sep_width - name_display_w - 2) / 2 ))
right_len=$(( sep_width - name_display_w - 2 - left_len ))
(( left_len < 1 )) && left_len=1
(( right_len < 1 )) && right_len=1
printf "%b\n" "${dim}$(printf '─%.0s' $(seq 1 $left_len)) ${white}${buddy_name}${reset} ${dim}$(printf '─%.0s' $(seq 1 $right_len))${reset}"

# ─── Run original statusline (if saved) ──────────────────────────────────────
ORIGINAL="$HOME/.claude-buddy/original-statusline-command.sh"
if [ -f "$ORIGINAL" ]; then
  echo "$input" | bash "$ORIGINAL"
fi
