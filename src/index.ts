import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { showTool } from "./tools/show.js";
import { artTool } from "./tools/art.js";
import { sayTool } from "./tools/say.js";
import { renameTool } from "./tools/rename.js";

const server = new McpServer({
  name: "claude-buddy",
  version: "1.0.0",
});

server.tool("buddy_show", showTool.description, {}, async () => {
  return await showTool.handler();
});

server.tool("buddy_art", artTool.description, { ascii: z.string().describe("커스텀 ASCII 아트 (빈 문자열=초기화)") }, async (args) => {
  return await artTool.handler(args);
});

server.tool("buddy_say", sayTool.description, { message: z.string().describe("말풍선 대사 (빈 문자열=제거)") }, async (args) => {
  return await sayTool.handler(args);
});

server.tool("buddy_rename", renameTool.description, { name: z.string().describe("새 이름") }, async (args) => {
  return await renameTool.handler(args);
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((err) => {
  console.error("Failed to start buddy MCP server:", err);
  process.exit(1);
});
