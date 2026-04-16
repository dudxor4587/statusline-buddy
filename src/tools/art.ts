import { loadState, saveState } from "../state.js";
import { t } from "../i18n.js";

export const artTool = {
  name: "buddy_art",
  description: "Set custom ASCII art or reset to default (empty string = reset).",
  inputSchema: {
    type: "object" as const,
    properties: {
      ascii: { type: "string", description: "Custom ASCII art (empty = reset)" },
    },
    required: ["ascii"],
  },
  async handler(args: { ascii: string }) {
    const state = await loadState();
    state.art = args.ascii || null;
    await saveState(state);
    const msg = args.ascii
      ? t("art_changed", state.lang) as string
      : t("art_reset", state.lang) as string;
    return { content: [{ type: "text" as const, text: msg }] };
  },
};
