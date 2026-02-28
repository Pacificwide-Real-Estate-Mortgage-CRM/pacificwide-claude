# Claude Code Team Workflow

## Workflows

### Feature Development

```
/plan → /implement → /review → /commit
```

| Step | Skill        | What it does                                        | When to use         |
| ---- | ------------ | --------------------------------------------------- | ------------------- |
| 1    | `/plan`      | Read Notion ticket → analyze codebase → create plan | Medium/large tasks  |
| 2    | `/implement` | Code based on plan, follow standards, run tests     | All features        |
| 3    | `/review`    | Review code quality → fix issues → verify           | Before commit       |
| 4    | `/commit`    | Lint → test → commit → update Notion                | After review passes |

### Bug Fixes

```
/fix → /review → /commit
```

| Step | Skill     | What it does                                               | When to use         |
| ---- | --------- | ---------------------------------------------------------- | ------------------- |
| 1    | `/fix`    | Reproduce → debug → fix → regression test                  | All bug fixes       |
| 2    | `/review` | Review code quality → fix issues → verify                  | Before commit       |
| 3    | `/commit` | Lint → test → commit → update Notion                       | After review passes |

## File Structure

```
.claude/
├── agents/
│   ├── code-reviewer.md    # Reviews diff against project standards
│   ├── tester.md           # Runs tests, reports failures
│   └── debugger.md         # Investigates bugs, finds root cause
├── rules/
│   └── development-rules.md  # Team standards (always loaded)
└── skills/
    ├── plan/SKILL.md       # /plan workflow (features)
    ├── implement/SKILL.md  # /implement workflow (features)
    ├── fix/SKILL.md        # /fix workflow (bugs)
    ├── review/SKILL.md     # /review workflow (all)
    └── commit/SKILL.md     # /commit workflow (all)
```

## How to Use

### Bug fix:

```bash
/fix [Notion ticket link or bug description]
/review
/commit
```

### Simple feature (single file):

```bash
/implement [task description or Notion link]
/review
/commit
```

### Complex feature (multiple files):

```bash
/plan [Notion ticket link]
/implement plans/task-name.md
/review
/commit
```

### Full workflow examples:

**Feature workflow:**
```
/plan → creates plans/task.md + updates Notion → prints "Next: /implement plans/task.md"
  ↓
/implement plans/task.md → follows plan checklist → marks [x] → prints "Next: /review"
  ↓
/review → project checks + code-reviewer agent → fixes issues → prints "Next: /commit"
  ↓
/commit → verify review → branch check → sync plan → stage → commit → Notion → push → done
```

**Bug fix workflow:**
```
/fix [ticket] → reproduce → debug → fix → regression test → prints "Next: /review"
  ↓
/review → project checks + code-reviewer agent → fixes issues → prints "Next: /commit"
  ↓
/commit → verify review → branch check → stage → commit → Notion → push → done
```

## Agents

| Agent         | Purpose                               | Model  | Called by                               |
| ------------- | ------------------------------------- | ------ | --------------------------------------- |
| code-reviewer | Review diff against project rules     | sonnet | `/review` skill                         |
| tester        | Run tests, report failures            | haiku  | `/implement`, `/fix`, and `/review`     |
| debugger      | Investigate failures, find root cause | sonnet | `/fix` skill and when tests fail        |

## Required MCPs

| MCP      | Purpose                                | Required    |
| -------- | -------------------------------------- | ----------- |
| Notion   | Read tickets, update status/checklists | Yes         |
| Context7 | Look up library/framework docs         | Recommended |
