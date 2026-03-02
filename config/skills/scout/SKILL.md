---
name: ck:scout
description: "Fast codebase scouting using parallel agents. Use for file discovery, task context gathering, quick searches across directories. Supports internal (Explore) and external (Gemini/OpenCode) agents."
version: 1.0.0
argument-hint: "[search-target] [ext]"
---

# /scout — Fast Parallel Codebase Search

Token-efficient codebase scouting via parallel agents.

## Usage

- Default: spawn Explore subagents in parallel (see `references/internal-scouting.md`)
- `ext`: use Gemini/OpenCode CLI tools (see `references/external-scouting.md`)

When to use: starting a feature, debugging file relationships, locating functionality, before changes affecting multiple files.

## Workflow

1. **Analyze** — parse prompt for search targets; identify key directories, patterns, file types
2. **Estimate scale** — use Grep + Glob to gauge codebase size; determine agent count
3. **Divide** — split codebase into logical segments, no overlap, max coverage
4. **Register tasks** — skip if ≤ 2 agents; else `TaskCreate` per agent with scope metadata
5. **Spawn parallel agents** — `TaskUpdate` to `in_progress` before each spawn; each agent returns summary
6. **Collect** — timeout 3 min per agent; aggregate findings into single report

## Report Format

```markdown
# Scout Report
## Relevant Files
- `path/to/file.ts` - Brief description
## Unresolved Questions
- Any gaps
```

## Rules

- Each subagent has <200K token context window — scope prompts accordingly
- Gemini model: read from `$HOME/.claude/.ck.json`: `gemini.model`
- Log timed-out agents in report; do not block on non-responders
