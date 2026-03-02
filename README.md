# pacificwide-claude

Distribute team `.claude/` config to any repo. One command to sync agents, rules, and skills across all Pacificwide projects — with automatic stack detection.

> **📁 Browse config →** [github.com/.../config](https://github.com/Pacificwide-Real-Estate-Mortgage-CRM/pacificwide-claude/tree/main/config) — agents, rules, skills, stack configs

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Pacificwide-Real-Estate-Mortgage-CRM/pacificwide-claude/main/install.sh | bash
```

This clones the repo to `~/.pacificwide-claude/` and adds the CLI to your PATH.

## Usage

### Initialize a project

```bash
cd your-project
pacificwide-claude init
```

Auto-detects your stack from `package.json` and copies shared config + stack-specific rules and skills into `.claude/`. Pre-configured MCP servers (Figma, Notion) are set up automatically. Protected files (`.env`, `settings.local.json`, `.mcp.json`) are never overwritten.

Override auto-detection:

```bash
pacificwide-claude init --stack=nextjs
```

### Update config

```bash
pacificwide-claude update
```

Pulls latest config from the repo and syncs to `.claude/`. Remembers your stack from previous init.

### Check setup

```bash
pacificwide-claude doctor
```

Verifies CLI installation, `.claude/` structure, stack detection, Node.js version, and tooling.

### List config

```bash
pacificwide-claude list           # Show all (agents, rules, skills, stacks)
pacificwide-claude list agents    # Show agents only
pacificwide-claude list skills    # Show skills only
pacificwide-claude list stacks    # Show available stacks
```

### Initialize project docs

```bash
pacificwide-claude docs init
```

Creates `docs/` with stub templates (`code-standards.md`, `codebase-summary.md`, `system-architecture.md`, `deployment-guide.md`). Skips files that already exist.

Then run `/docs init` in Claude Code to have AI analyze your codebase and fill in the stubs automatically.

**Docs workflow:**
```
pacificwide-claude docs init   → create stubs
/docs init                     → AI fills docs from codebase analysis
/docs update                   → update after each feature
/docs summarize                → refresh codebase-summary.md only
```

### Reset

```bash
pacificwide-claude reset
```

Removes `.claude/` and re-initializes. Backs up and restores `.env`, `settings.local.json`, and `.mcp.json`.

### Self-update

```bash
pacificwide-claude self-update
```

Pulls the latest CLI version.

## Multi-stack support

The CLI auto-detects your stack from `package.json`:

| Stack          | Detection key    | What gets copied                          |
| -------------- | ---------------- | ----------------------------------------- |
| NestJS (BE)    | `@nestjs/core`   | stack-rules.md + backend-development, databases |
| Next.js (FE)   | `next`           | stack-rules.md + frontend-development, web-frameworks, react-best-practices, ui-styling, web-testing |
| React Native   | `react-native`   | stack-rules.md + mobile-development       |

Each project gets:
- **Shared config** — agents, rules, skills (same for all stacks)
- **Stack rules** — `.claude/rules/stack-rules.md` with framework-specific patterns, commands, review checklists
- **Stack skills** — stack-specific skills copied to `.claude/skills/`

## What gets synced

```
config/
├── README.MD                        # Workflow overview (→ .claude/)
├── agents/                          # 10 agents (→ .claude/agents/)
│   ├── code-reviewer.md
│   ├── tester.md
│   ├── debugger.md
│   ├── planner.md
│   ├── researcher.md
│   ├── fullstack-developer.md
│   ├── docs-manager.md
│   ├── code-simplifier.md
│   ├── project-manager.md
│   └── ui-ux-designer.md
├── rules/                           # Shared rules (→ .claude/rules/)
│   └── development-rules.md
├── skills/                          # 17 shared skills (→ .claude/skills/)
│   ├── plan/                        # /plan — task planning
│   ├── implement/                   # /implement — feature implementation
│   ├── fix/                         # /fix — bug fixing
│   ├── review/                      # /review — code review
│   ├── commit/                      # /commit — commit with checks
│   ├── docs/                        # /docs — generate + manage project docs
│   ├── docs-seeker/                 # Library docs lookup
│   ├── sequential-thinking/         # Systematic analysis
│   ├── problem-solving/             # When stuck
│   ├── research/                    # Tech research
│   ├── brainstorm/                  # Solution exploration
│   ├── preview/                     # Visual explanations
│   ├── mermaidjs-v11/               # Diagrams
│   ├── scout/                       # Fast codebase search
│   ├── debug/                       # Systematic debugging
│   ├── git/                         # Git operations
│   └── ai-multimodal/              # Image/video analysis
└── stacks/                          # Stack-specific config
    ├── nestjs/
    │   ├── stack-rules.md
    │   └── skills/ (2 skills)
    ├── nextjs/
    │   ├── stack-rules.md
    │   └── skills/ (5 skills)
    └── react-native/
        ├── stack-rules.md
        └── skills/ (1 skill)
```

## MCP servers

Pre-configured via `.mcp.json.example` (copied to `.claude/.mcp.json` on first `init`):

| MCP    | URL                          | Purpose                              |
| ------ | ---------------------------- | ------------------------------------ |
| Figma  | `https://mcp.figma.com/mcp`  | Read designs, extract tokens, gen code |
| Notion | `https://mcp.notion.com/mcp` | Read tickets, update status, comments |

**First-time auth:** Open Claude Code → `/mcp` → select server → Authenticate → Allow access.

Or add manually: `claude mcp add --transport http figma https://mcp.figma.com/mcp`

## Protected files

These files are **never overwritten** by `init`, `update`, or `reset`:

- `.mcp.json` — MCP server configuration (project root — Claude Code reads from here)
- `.claude/.env` — Local environment variables
- `.claude/settings.local.json` — Local Claude settings
- `.claude/.pacificwide-meta.json` — Sync metadata (updated, not overwritten)

## Team workflow

After running `pacificwide-claude init`, use these skills in Claude Code:

**Feature development:**
```
/plan → /implement → /review → /commit
```

**Bug fixes:**
```
/fix → /review → /commit
```

See `config/README.MD` for detailed workflow documentation.

## Adding new config

1. Add files to `config/` in this repo
2. For stack-specific content, add to `config/stacks/<stack>/`
3. Commit and push
4. Team members run `pacificwide-claude update` to get the new config

## Requirements

- git
- Node.js >= 18
- Claude Code CLI (recommended)
