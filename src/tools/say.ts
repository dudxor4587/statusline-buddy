import { loadState, saveState } from "../state.js";

export const sayTool = {
  name: "buddy_say",
  description: "버디에게 특정 대사를 말하게 합니다. 빈 문자열이면 말풍선을 제거합니다.",
  inputSchema: {
    type: "object" as const,
    properties: {
      message: { type: "string", description: "말풍선 대사 (빈 문자열=제거)" },
    },
    required: ["message"],
  },
  async handler(args: { message: string }) {
    const state = await loadState();
    state.speech = args.message || null;
    await saveState(state);
    return { content: [{ type: "text" as const, text: args.message ? `💬 ${args.message}` : "말풍선 제거." }] };
  },
};
