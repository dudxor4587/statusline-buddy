import { loadState, saveState } from "../state.js";
import { t } from "../i18n.js";

export const sayTool = {
  name: "buddy_say",
  description: "Set buddy speech bubble. Empty string removes it.",
  inputSchema: {
    type: "object" as const,
    properties: {
      message: { type: "string", description: "Speech text (empty = clear)" },
    },
    required: ["message"],
  },
  async handler(args: { message: string }) {
    const state = await loadState();
    state.speech = args.message || null;
    await saveState(state);
    const msg = args.message
      ? `${t("say_set", state.lang)} ${args.message}`
      : t("say_cleared", state.lang) as string;
    return { content: [{ type: "text" as const, text: msg }] };
  },
};
