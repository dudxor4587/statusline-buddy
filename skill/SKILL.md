# /buddy

커스텀 버디를 관리하는 명령입니다.

## 사용법

사용자가 `/buddy` 또는 `/buddy <subcommand>`를 입력하면, 아래 규칙에 따라 적절한 MCP 도구를 호출하세요.

## 명령 라우팅

| 명령 | MCP 도구 | 설명 |
|------|----------|------|
| `/buddy` | `buddy_show` | 버디 카드 보기 |
| `/buddy art <ASCII>` | `buddy_art` | ASCII 아트 등록 (`ascii` 파라미터, 빈 문자열=초기화) |
| `/buddy say <메시지>` | `buddy_say` | 대사 표시 (`message` 파라미터, 빈 문자열=제거) |
| `/buddy rename <이름>` | `buddy_rename` | 이름 변경 (`name` 파라미터) |

## 주의사항

- MCP 도구 호출 결과를 그대로 사용자에게 보여주세요.
