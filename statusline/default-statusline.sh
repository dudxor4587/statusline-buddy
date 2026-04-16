#!/usr/bin/env bash

input=$(cat)

reset=$'\033[0m'
dim=$'\033[90m'
red=$'\033[31m'
white=$'\033[37m'

# Parse JSON input with node
eval "$(echo "$input" | node -e "
  const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
  console.log('cwd='+JSON.stringify(d.workspace?.current_dir||''));
  console.log('model='+JSON.stringify((d.model?.display_name||'Unknown').replace(/ \(.*\)$/,'')));
  console.log('used_pct='+JSON.stringify(String(d.context_window?.used_percentage||0)));
" 2>/dev/null)"

folder=$(basename "$cwd")

# Git branch (truncate to 20 chars)
branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  if [ ${#branch} -gt 20 ]; then
    branch="${branch:0:20}…"
  fi
fi

# Context bar
used_int=${used_pct%.*}
used_int=${used_int:-0}

bar_filled=$(( used_int / 10 ))
bar_empty=$(( 10 - bar_filled ))
bar=""
for ((i=0; i<bar_filled; i++)); do bar+="█"; done
for ((i=0; i<bar_empty; i++)); do bar+="░"; done

if [ "$used_int" -lt 80 ]; then
  bar_color=$dim
else
  bar_color=$red
fi

# Line 1: folder | branch
line1="📁 ${white}${folder}${reset}"
if [ -n "$branch" ]; then
  line1+=" ${dim}│${reset} 🌿 ${white}${branch}${reset}"
fi

# Line 2: model | context
line2="🤖 ${white}${model}${reset} ${dim}│${reset} 📊 ${bar_color}${bar} ${used_int}%${reset}"

printf "%b\n" "$line1"
printf "%b\n" "$line2"
