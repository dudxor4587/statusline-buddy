# statusline-buddy

A custom ASCII buddy that lives in your Claude Code status line.

```
 |\/\/\/|
 |      |
 | (o)(o)
 C      _)   💬 Hello!
  | ,___|
  |   /
 /____\
/      \
──── Buddy ────
📁 my-project │ 🌿 main
🤖 Opus 4.6 │ 📊 ██░░░░░░░░ 20%
```

## Features

- **Custom ASCII art** — set any ASCII art as your buddy
- **Speech bubble** — make your buddy say things
- **Naming** — give your buddy a name (shown in the separator)
- **Language support** — Korean and English
- **Non-destructive** — wraps your existing status line, doesn't replace it

## Install

```bash
git clone https://github.com/dudxor4587/statusline-buddy.git
cd statusline-buddy
./scripts/install.sh
```

During installation, you'll be asked to choose your statusline setup:

| Option | Description |
|--------|-------------|
| **1) Buddy only** | Just the buddy art, no extra info |
| **2) Buddy + bundled statusline** | Buddy + folder, branch, model, context bar ([preview](#bundled-statusline)) |
| **3) Buddy + your existing statusline** | Buddy above your current statusline (only if one is detected) |

Restart Claude Code after installation.

## Uninstall

```bash
./scripts/uninstall.sh
```

Your original status line will be restored.

## Commands

| Command | Description |
|---------|-------------|
| `/buddy` | Show buddy status |
| `/buddy art <ascii>` | Set custom ASCII art (empty = reset) |
| `/buddy say <message>` | Set speech bubble (empty = clear) |
| `/buddy rename <name>` | Rename your buddy |
| `/buddy lang <ko\|en>` | Change language |
| `/buddy help` | Show available commands |

## Bundled statusline

Option 2 includes a statusline that shows project info below the buddy:

```
📁 my-project │ 🌿 main
🤖 Opus 4.6 │ 📊 ██░░░░░░░░ 20%
```

## How it works

- **MCP server** handles buddy commands and saves state to `~/.statusline-buddy/profile.json`
- **Status line wrapper** reads `profile.json` and renders the buddy above your chosen status line
- Your original status line is backed up during install and restored on uninstall

## Requirements

- [Claude Code](https://claude.ai/claude-code) (CLI)
- Node.js 18+
