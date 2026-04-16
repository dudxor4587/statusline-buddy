import { loadState, saveState } from "../state.js";

export const renameTool = {
  name: "buddy_rename",
  description: "버디의 이름을 변경합니다.",
  inputSchema: {
    type: "object" as const,
    properties: {
      name: { type: "string", description: "새 이름" },
    },
    required: ["name"],
  },
  async handler(args: { name: string }) {
    const state = await loadState();
    const old = state.name;
    state.name = args.name;
    await saveState(state);
    return { content: [{ type: "text" as const, text: `"${old}" → "${args.name}"` }] };
  },
};
