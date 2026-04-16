# /buddy

Manage your custom buddy in the status line.

## Usage

When the user types `/buddy` or `/buddy <subcommand>`, call the appropriate MCP tool.

## Routing

| Command | MCP Tool | Description |
|---------|----------|-------------|
| `/buddy` | `buddy_show` | Show buddy status |
| `/buddy art <ASCII>` | `buddy_art` | Set ASCII art (`ascii` param, empty = reset) |
| `/buddy say <message>` | `buddy_say` | Set speech bubble (`message` param, empty = clear) |
| `/buddy rename <name>` | `buddy_rename` | Rename buddy (`name` param) |
| `/buddy lang <ko\|en>` | `buddy_lang` | Change language (`lang` param) |
| `/buddy help` | `buddy_help` | Show available commands |

## Notes

- Show MCP tool results to the user as-is.
