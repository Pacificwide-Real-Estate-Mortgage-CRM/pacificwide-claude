# pacificwide-claude

Distribute team `.claude/` config to any repo. One command to sync agents, rules, and skills across all Pacificwide projects.

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

Copies team config into `.claude/`. Protected files (`.env`, `settings.local.json`, `.mcp.json`) are never overwritten.

### Update config

```bash
pacificwide-claude update
```

Pulls latest config from the repo and syncs to `.claude/`. Local protected files are preserved.

### Check setup

```bash
pacificwide-claude doctor
```

Verifies CLI installation, `.claude/` structure, Node.js version, and tooling.

### List config

```bash
pacificwide-claude list           # Show all
pacificwide-claude list agents    # Show agents only
pacificwide-claude list rules     # Show rules only
pacificwide-claude list skills    # Show skills only
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

## What gets synced

```
config/
├── README.MD                    # Workflow overview
├── agents/
│   ├── code-reviewer.md         # Code review agent
│   ├── tester.md                # Test runner agent
│   └── debugger.md              # Debug investigation agent
├── rules/
│   └── development-rules.md     # Team coding standards
└── skills/
    ├── plan/SKILL.md            # /plan — task planning
    ├── implement/SKILL.md       # /implement — feature implementation
    ├── review/SKILL.md          # /review — code review
    ├── fix/SKILL.md             # /fix — bug fixing
    └── commit/SKILL.md          # /commit — commit with checks
```

## Protected files

These files are **never overwritten** by `init`, `update`, or `reset`:

- `.claude/.env` — Local environment variables
- `.claude/settings.local.json` — Local Claude settings
- `.claude/.mcp.json` — MCP server configuration
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
2. Commit and push
3. Team members run `pacificwide-claude update` to get the new config

## Requirements

- git
- Node.js >= 18
- Claude Code CLI (recommended)
