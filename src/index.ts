import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { showTool } from "./tools/show.js";
import { artTool } from "./tools/art.js";
import { sayTool } from "./tools/say.js";
import { renameTool } from "./tools/rename.js";
import { langTool } from "./tools/lang.js";
import { helpTool } from "./tools/help.js";

const server = new McpServer({
  name: "statusline-buddy",
  version: "1.0.0",
});

server.tool("buddy_show", showTool.description, {}, async () => {
  return await showTool.handler();
});

server.tool("buddy_art", artTool.description, { ascii: z.string().describe("Custom ASCII art (empty = reset)") }, async (args) => {
  return await artTool.handler(args);
});

server.tool("buddy_say", sayTool.description, { message: z.string().describe("Speech text (empty = clear)") }, async (args) => {
  return await sayTool.handler(args);
});

server.tool("buddy_rename", renameTool.description, { name: z.string().describe("New name") }, async (args) => {
  return await renameTool.handler(args);
});

server.tool("buddy_lang", langTool.description, { lang: z.string().describe("Language: ko or en") }, async (args) => {
  return await langTool.handler(args);
});

server.tool("buddy_help", helpTool.description, {}, async () => {
  return await helpTool.handler();
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((err) => {
  console.error("Failed to start buddy MCP server:", err);
  process.exit(1);
});
