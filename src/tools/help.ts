import { loadState } from "../state.js";
import type { Lang } from "../state.js";

const helpText: Record<Lang, string> = {
  ko: [
    "/buddy          — 버디 상태 보기",
    "/buddy art      — ASCII 아트 변경 (빈값=초기화)",
    "/buddy say      — 말풍선 설정 (빈값=제거)",
    "/buddy rename   — 이름 변경",
    "/buddy lang     — 언어 변경 (ko/en)",
    "/buddy help     — 이 도움말",
  ].join("\n"),
  en: [
    "/buddy          — Show buddy status",
    "/buddy art      — Set ASCII art (empty = reset)",
    "/buddy say      — Set speech bubble (empty = clear)",
    "/buddy rename   — Rename buddy",
    "/buddy lang     — Change language (ko/en)",
    "/buddy help     — Show this help",
  ].join("\n"),
};

export const helpTool = {
  name: "buddy_help",
  description: "Show available buddy commands.",
  inputSchema: { type: "object" as const, properties: {} },
  async handler() {
    const state = await loadState();
    return { content: [{ type: "text" as const, text: helpText[state.lang] }] };
  },
};
