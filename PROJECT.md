# claude-buddy-custom

Claude Code용 커스텀 버디 MCP 서버.

## 배경

Claude Code v2.1.97에서 내장 `/buddy` 기능이 삭제됨. 기존 오픈소스(claude-buddy)는 렌더링 깨짐 + MCP 연결 불안정 이슈. 직접 만들기로 결정.

## 기능 목록

### 필수
- `/buddy` — 내 버디 ASCII 아트 카드 보기
- `/buddy pet` — 쓰다듬기 (리액션)
- `/buddy rename <이름>` — 이름 변경

### 커스텀
- `/buddy art` — ASCII 아트 직접 등록/수정
- `/buddy hat <종류>` — 모자 변경
- `/buddy eye <종류>` — 눈 변경

### 상태
- `/buddy stats` — 스탯 보기
- `/buddy save` / `/buddy load` — 프로필 저장/불러오기

### 분위기
- `/buddy say <메시지>` — 말풍선에 특정 대사 표시
- `/buddy mood <기분>` — 표정 변경

## 기술 스택

- **Runtime**: Node.js (bun 의존 없이)
- **MCP SDK**: `@modelcontextprotocol/sdk`
- **상태 저장**: `~/.claude-buddy/` 밑에 JSON 파일
- **언어**: TypeScript

## 프로젝트 구조

```
claude-buddy-custom/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts          # MCP 서버 진입점
│   ├── tools/            # tool 핸들러들
│   │   ├── show.ts       # /buddy
│   │   ├── pet.ts        # /buddy pet
│   │   ├── rename.ts     # /buddy rename
│   │   ├── art.ts        # /buddy art (커스텀 ASCII)
│   │   ├── hat.ts        # /buddy hat
│   │   ├── eye.ts        # /buddy eye
│   │   ├── stats.ts      # /buddy stats
│   │   ├── save.ts       # /buddy save/load
│   │   ├── say.ts        # /buddy say
│   │   └── mood.ts       # /buddy mood
│   ├── state.ts          # 상태 읽기/쓰기 (~/.claude-buddy/)
│   └── ascii.ts          # 기본 ASCII 아트 템플릿
├── skill/
│   └── SKILL.md          # /buddy 명령 라우팅
└── README.md
```

## 등록 방식

```bash
claude mcp add my-buddy -- npx tsx src/index.ts
```

## 참고

- MCP SDK: https://modelcontextprotocol.io
- Claude Code MCP 등록: `claude mcp add <name> -- <command>`
- stdio transport (포트 필요 없음, Claude Code가 프로세스 관리)
- SKILL.md를 `~/.claude/skills/buddy/`에 복사하면 `/buddy` 명령으로 라우팅됨
