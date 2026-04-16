import { loadState } from "../state.js";

export const showTool = {
  name: "buddy_show",
  description: "버디 상태를 확인합니다.",
  inputSchema: { type: "object" as const, properties: {} },
  async handler() {
    const state = await loadState();
    const msg = state.speech ? `💬 ${state.speech}` : "버디가 status line에 표시됩니다.";
    return { content: [{ type: "text" as const, text: msg }] };
  },
};
