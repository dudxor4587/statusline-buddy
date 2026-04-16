import type { Lang } from "./state.js";

const messages = {
  art_changed: { ko: "아트 변경 완료.", en: "Art updated." },
  art_reset: { ko: "기본 아트로 초기화.", en: "Reset to default art." },
  say_set: { ko: "💬", en: "💬" },
  say_cleared: { ko: "말풍선 제거.", en: "Speech cleared." },
  rename_result: { ko: (o: string, n: string) => `"${o}" → "${n}"`, en: (o: string, n: string) => `"${o}" → "${n}"` },
  show_status: { ko: "버디가 status line에 표시됩니다.", en: "Buddy is shown in the status line." },
  show_speech: { ko: "💬", en: "💬" },
  lang_changed: { ko: (l: string) => `언어가 ${l}(으)로 변경되었습니다.`, en: (l: string) => `Language changed to ${l}.` },
  lang_invalid: { ko: "지원하는 언어: ko, en", en: "Supported languages: ko, en" },
} as const;

type Key = keyof typeof messages;

export function t(key: Key, lang: Lang): string | ((...args: string[]) => string) {
  return messages[key][lang];
}
