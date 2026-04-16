import { loadState } from "../state.js";
import { t } from "../i18n.js";

export const showTool = {
  name: "buddy_show",
  description: "Show buddy status.",
  inputSchema: { type: "object" as const, properties: {} },
  async handler() {
    const state = await loadState();
    const msg = state.speech
      ? `${t("show_speech", state.lang)} ${state.speech}`
      : t("show_status", state.lang) as string;
    return { content: [{ type: "text" as const, text: msg }] };
  },
};
