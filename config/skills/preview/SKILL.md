---
name: ck:preview
description: "View files/directories OR generate visual explanations, slides, diagrams."
argument-hint: "[path] OR --explain|--slides|--diagram|--ascii [topic]"
---

# /preview — Visual Viewer + Generator

View existing content or generate visual explanations (ASCII + Mermaid + prose).

## Usage

- `/ck:preview <file.md>` — view markdown file
- `/ck:preview <directory/>` — browse directory
- `/ck:preview --explain <topic>` — visual explanation (ASCII + Mermaid + prose)
- `/ck:preview --slides <topic>` — presentation slides (one concept per slide)
- `/ck:preview --diagram <topic>` — focused diagram (ASCII + Mermaid)
- `/ck:preview --ascii <topic>` — ASCII-only, terminal-friendly
- `/ck:preview --stop` — stop preview server

## Workflow

1. Check for `--stop` → stop server
2. Check for generation flags (`--explain`, `--slides`, `--diagram`, `--ascii`) → load `references/generation-modes.md`
3. Resolve path from argument → if exists, load `references/view-mode.md`
4. If unresolvable → ask user to clarify
5. If no arguments → ask user which operation via `AskUserQuestion`

## Rules

- Topic slug: lowercase, spaces→hyphens, max 80 chars, truncate at word boundary
- Multiple flags: use first only; rest treated as topic
- Output path: from `## Plan Context` hook → plan folder; fallback → `plans/visuals/`
- Existing file at output path: overwrite silently
- Missing parent dirs: create recursively before write
