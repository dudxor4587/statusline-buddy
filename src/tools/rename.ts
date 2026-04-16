import { loadState, saveState } from "../state.js";
import { t } from "../i18n.js";

export const renameTool = {
  name: "buddy_rename",
  description: "Rename your buddy.",
  inputSchema: {
    type: "object" as const,
    properties: {
      name: { type: "string", description: "New name" },
    },
    required: ["name"],
  },
  async handler(args: { name: string }) {
    const state = await loadState();
    const old = state.name;
    state.name = args.name;
    await saveState(state);
    const fn = t("rename_result", state.lang) as (o: string, n: string) => string;
    return { content: [{ type: "text" as const, text: fn(old, args.name) }] };
  },
};
