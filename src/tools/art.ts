import { loadState, saveState } from "../state.js";

export const artTool = {
  name: "buddy_art",
  description: "버디의 ASCII 아트를 직접 등록하거나 초기화합니다. 빈 문자열이면 기본 아트로 초기화합니다.",
  inputSchema: {
    type: "object" as const,
    properties: {
      ascii: { type: "string", description: "커스텀 ASCII 아트 (빈 문자열=초기화)" },
    },
    required: ["ascii"],
  },
  async handler(args: { ascii: string }) {
    const state = await loadState();
    state.art = args.ascii || null;
    await saveState(state);
    return { content: [{ type: "text" as const, text: args.ascii ? "아트 변경 완료." : "기본 아트로 초기화." }] };
  },
};
