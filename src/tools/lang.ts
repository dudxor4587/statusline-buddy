import { loadState, saveState, type Lang } from "../state.js";
import { t } from "../i18n.js";

const SUPPORTED: Lang[] = ["ko", "en"];

export const langTool = {
  name: "buddy_lang",
  description: "Change buddy language (ko/en).",
  inputSchema: {
    type: "object" as const,
    properties: {
      lang: { type: "string", description: "Language: ko or en" },
    },
    required: ["lang"],
  },
  async handler(args: { lang: string }) {
    if (!SUPPORTED.includes(args.lang as Lang)) {
      const state = await loadState();
      return { content: [{ type: "text" as const, text: t("lang_invalid", state.lang) as string }], isError: true };
    }
    const state = await loadState();
    state.lang = args.lang as Lang;
    await saveState(state);
    const fn = t("lang_changed", state.lang) as (l: string) => string;
    return { content: [{ type: "text" as const, text: fn(args.lang) }] };
  },
};
