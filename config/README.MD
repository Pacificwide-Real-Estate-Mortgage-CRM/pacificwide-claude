# Claude Code Team Workflow

## Stacks

Auto-detects stack from `package.json`:

| Stack        | Detection key  | Stack rules            |
| ------------ | -------------- | ---------------------- |
| NestJS (BE)  | `@nestjs/core` | `stacks/nestjs/`       |
| Next.js (FE) | `next`         | `stacks/nextjs/`       |
| React Native | `react-native` | `stacks/react-native/` |

Each stack provides `stack-rules.md` (patterns, commands, review checklist) and `skills/` (stack-specific skills).

---

## Use Cases

### Case 1: Single-stack feature (BE-only or FE-only)

```
  Notion Ticket (Stacks: [BE])
          │
          ▼
  ┌───────────────┐
  │  /plan [ticket]│ ── Creates branch ── Creates plan file
  └───────┬───────┘    feat/TICKET-123/    plans/task.md
          │            payment-webhook
          ▼                                Posts to Notion:
  ┌───────────────┐                        "📋 Plan created"
  │  /implement   │ ── Follow plan ── Write code ── Run tests
  └───────┬───────┘
          │
          ▼
  ┌───────────────┐
  │  /review      │ ── code-reviewer agent ── Fix issues ── Re-verify
  └───────┬───────┘
          │
          ▼
  ┌───────────────┐    Posts to Notion:
  │  /commit      │ ── "✅ BE committed" ── Creates PR ── Push
  └───────────────┘
```

**Example:** "Add payment webhook" (BE-only)

```bash
# In BE repo
/plan https://notion.so/ticket/123
  # → Creates branch: feat/TICKET-123/payment-webhook
  # → Creates plans/payment-webhook.md
  # → Updates Notion: status → "In Progress"

/implement plans/payment-webhook.md
/review
/commit
  # → Creates PR via gh pr create
  # → Comments on Notion: "✅ BE committed"
```

### Case 2: Cross-stack feature (BE + FE)

**Concept:** Plan per-repo, API contract shared via Notion.

```
  Notion Ticket (Stacks: [BE, FE])
          │
          ├─────────── BE Repo ───────────────────────────────────────┐
          │                                                           │
          ▼                                                           │
  ┌───────────────┐                                                   │
  │  /plan [ticket]│ ── detect: nestjs ── Create BE plan              │
  └───────┬───────┘    Create branch      Post API contract           │
          │            feat/TICKET-456/    to Notion                   │
          ▼            user-profile-api                                │
  ┌───────────────┐                                                   │
  │  /implement   │ ── BE code only                                   │
  └───────┬───────┘                                                   │
          ▼                                                           │
  ┌───────────────┐                                                   │
  │  /review      │                                                   │
  └───────┬───────┘                                                   │
          ▼                                                           │
  ┌───────────────┐    Notion: "✅ BE committed"                      │
  │  /commit      │ ── Creates PR ── Handoff:                         │
  └───────────────┘    "Switch to FE repo"                            │
                                                                      │
          ├─────────── FE Repo ───────────────────────────────────────┘
          │            (after BE committed, or parallel)
          ▼
  ┌───────────────┐
  │  /plan [ticket]│ ── detect: nextjs ── Read API contract from Notion
  └───────┬───────┘    Create branch      Create FE plan
          │            feat/TICKET-456/
          ▼            user-profile-ui
  ┌───────────────┐
  │  /implement   │ ── FE code only (uses API contract)
  └───────┬───────┘
          ▼
  ┌───────────────┐
  │  /review      │
  └───────┬───────┘
          ▼
  ┌───────────────┐    Notion: "✅ FE committed"
  │  /commit      │ ── Creates PR ── "All stacks done"
  └───────────────┘
```

**Example:** "Add user profile page" (needs API + UI)

```bash
# Step 1: BE repo (API first)
/plan https://notion.so/ticket/456
  # → Reads Notion → Stacks: [BE, FE]
  # → detect_stack() → "nestjs" → creates BE-scoped plan
  # → Creates branch: feat/TICKET-456/user-profile-api
  # → Posts API contract to Notion comment:
  #     GET /api/users/:id/profile → { name, email, avatar }
  #     PUT /api/users/:id/profile ← { name, avatar }
  # → Handoff: "Cross-stack task. After BE commit, switch to FE repo."

/implement plans/user-profile.md
/review
/commit
  # → Notion comment: "✅ BE committed: abc123"
  # → "Next: open FE repo, run /plan [ticket]"

# Step 2: FE repo (UI consumes API)
/plan https://notion.so/ticket/456
  # → Reads Notion → sees API contract from BE comment
  # → detect_stack() → "nextjs" → creates FE-scoped plan
  # → Creates branch: feat/TICKET-456/user-profile-ui
  # → Plan references API contract for endpoints/shapes

/implement plans/user-profile.md
/review
/commit
  # → Notion comment: "✅ FE committed: def456"
  # → "All stacks done. Create PRs."
```

**Parallel (2 devs):** Both devs run `/plan` on same ticket. FE dev starts after API contract is posted to Notion. FE can mock API initially, switch to real API after BE merges.

### Case 3: Simple bug fix (single-stack)

```
  Bug Ticket (Stacks: [FE])
          │
          ▼
  ┌───────────────┐
  │  /fix [ticket] │ ── Reproduce ── Debug (debugger agent)
  └───────┬───────┘    Find root cause ── Minimal fix
          │            Write regression test
          ▼
  ┌───────────────┐
  │  /review      │ ── Verify fix ── Check no side effects
  └───────┬───────┘
          ▼
  ┌───────────────┐
  │  /commit      │ ── Commit ── PR ── Notion: "✅ Fixed"
  └───────────────┘
```

```bash
# In the repo where the bug exists
/fix https://notion.so/ticket/789
/review
/commit
```

### Case 4: Cross-stack bug

**Concept:** Investigate in current repo → determine which stack has root cause → fix there → handoff if needed.

```
  Bug Ticket (Stacks: [BE, FE])
  "Profile shows wrong name"
          │
          ▼
  ┌─────────────────────────┐
  │  /fix [ticket] in FE    │ ── Investigate FE code
  └───────┬─────────────────┘    Call API → check response
          │
          ▼
  ┌─────────────────────────┐
  │  Root cause in FE?      │
  │                         │
  │  YES → fix here         │──── /review → /commit → Done
  │                         │
  │  NO → root cause in BE  │
  └───────┬─────────────────┘
          │
          ▼  Notion comment: "Root cause: BE API returns
             fullName instead of name"
          │
          ▼  Handoff: "Switch to BE repo"
  ┌─────────────────────────┐
  │  /fix [ticket] in BE    │ ── Reads Notion investigation
  └───────┬─────────────────┘    Fixes API ── Regression test
          │
          ▼
  /review → /commit → "✅ BE fix committed"
```

```bash
# FE repo — investigate
/fix https://notion.so/ticket/101
  # → Root cause is in BE
  # → Comments on Notion, handoff to BE repo

# BE repo — fix the actual bug
/fix https://notion.so/ticket/101
/review → /commit
```

### Case 5: Hotfix (production emergency)

**When:** Production down, security vulnerability, data corruption.

```
  🚨 Production Issue
          │
          ▼
  ┌───────────────────────────┐
  │  git checkout main        │ ── Branch from main (not develop)
  │  git checkout -b hotfix/  │
  │  TICKET-999/auth-bypass   │
  └───────┬───────────────────┘
          │
          ▼
  ┌───────────────────────────┐
  │  /fix [ticket]            │ ── Minimal fix only
  └───────┬───────────────────┘    No refactoring
          │                        Regression test required
          ▼
  ┌───────────────────────────┐
  │  /review                  │ ── Focus: security, data integrity
  └───────┬───────────────────┘    Skip: style, optimization
          │
          ▼
  ┌───────────────────────────┐
  │  /commit                  │ ── [hotfix] label in message
  └───────┬───────────────────┘    Auto-create PR with HOTFIX label
          │                        1 human approver (expedited)
          ▼
  ┌───────────────────────────┐
  │  Merge → Immediate Deploy │
  └───────┬───────────────────┘
          │
          ▼
  Notion: "🚨 HOTFIX: [root cause] → [fix] → [prevention]"


  Cross-stack hotfix: BE first → deploy → FE → deploy (sequential)
```

```bash
git checkout main && git pull
git checkout -b hotfix/TICKET-999/auth-bypass
/fix https://notion.so/ticket/999
/review
/commit
  # → PR with HOTFIX label → expedited review → immediate deploy
```

### Case 6: Simple change (no plan needed)

```
  Simple task (1-2 files)
          │
          ▼
  ┌─────────────────────────┐
  │  /implement "description"│ ── Write code ── Run tests
  └───────┬─────────────────┘    (no plan file needed)
          ▼
  /review → /commit
```

```bash
# Skip /plan for: single file, config tweak, typo fix, simple CRUD
/implement "add email field to user DTO"
/review
/commit
```

---

## Branch Strategy

### Naming convention

```
feat/TICKET-123/short-description     # New features
fix/TICKET-456/bug-description         # Bug fixes
hotfix/TICKET-789/critical-issue       # Production hotfixes
refactor/TICKET-012/cleanup            # Refactoring
```

**Cross-stack:** Same ticket ID, different slug per stack:
```
BE repo:  feat/TICKET-123/user-profile-api
FE repo:  feat/TICKET-123/user-profile-ui
```

### Branch lifecycle

```
main ── feat/TICKET-123/slug ── implement ── PR ── review ── merge ── delete
```

### Who creates branches

- **Features/bugs:** `/plan` auto-creates branch from ticket ID + description
- **Hotfixes:** Dev creates manually from main: `git checkout -b hotfix/TICKET-ID/slug`
- **If already on feature branch:** `/plan` skips branch creation

---

## PR & Merge Process

### PR creation

`/commit` auto-creates PR after successful push:
```
gh pr create --title "feat(TICKET-123): add user profile API" --body "..."
```
PR body auto-generated from plan file context + diff summary.

### PR review matrix

| Task type     | Claude /review | Human review        |
| ------------- | -------------- | ------------------- |
| Simple fix    | ✅ Sufficient  | Optional            |
| Small feature | ✅ Sufficient  | Optional            |
| Large feature | ✅ Required    | ✅ Required          |
| Cross-stack   | ✅ Required    | ✅ Required          |
| Security fix  | ✅ Required    | ✅ Required          |
| Hotfix        | ✅ Required    | ⚡ 1 approver        |

### Cross-stack merge order

**Rule:** BE PR merges first, FE PR merges after BE is deployed (or merged to main).
**Why:** FE depends on API availability.

---

## Notion Integration

### Ticket requirements

- **Stacks** property (multi-select): `BE`, `FE`, `App`
- **Spec document** linked from ticket (for /plan to read)
- Status field: `To Do`, `In Progress`, `Review`, `Done`

### Ticket lifecycle

```
To Do ──→ In Progress ──→ Review ──→ Done
  │           │              │         │
  │       /plan runs     All stacks  PR merged
  │       (auto)         committed   (manual)
  │                      + PR created
  │
  Ticket created by PM
```

| Transition              | Triggered by           | Who    |
| ----------------------- | ---------------------- | ------ |
| To Do → In Progress     | `/plan` creates branch | Claude |
| In Progress → Review    | `/commit` (last stack) | Claude |
| Review → Done           | PR merged + deployed   | Human  |

### Notion comments (auto-posted by skills)

```
Ticket #123 — "User Profile Page" — Stacks: [BE, FE]

📋 Plan created (BE)
   Branch: feat/TICKET-123/user-profile-api

📄 API Contract:
   GET /api/users/:id/profile → { name, email, avatar }
   PUT /api/users/:id/profile ← { name, avatar }

✅ BE committed: abc123
   feat(user): add profile API endpoints
   PR: github.com/org/be-repo/pull/45

📋 Plan created (FE)
   Branch: feat/TICKET-123/user-profile-ui

✅ FE committed: def456
   feat(profile): add profile page UI
   PR: github.com/org/fe-repo/pull/78
```

---

## Testing Strategy

### Per-stack testing

| Stack | Unit tests | Integration tests          | Tool          |
| ----- | ---------- | -------------------------- | ------------- |
| BE    | Service logic, validation | API endpoint + DB          | Jest          |
| FE    | Components, hooks         | Page + mocked API          | Vitest        |
| App   | Components, navigation    | Screen + mocked API        | Jest          |

### Cross-stack: API contract as test anchor

```
API Contract (from /plan, posted to Notion):
  GET /api/profile → { name: string, email: string }

BE test: "GET /profile returns { name, email }"     → verifies API shape
FE test: "renders correctly with { name, email }"   → verifies UI with expected shape
```

### Testing flow per task

| Task type           | Tests required                     |
| ------------------- | ---------------------------------- |
| BE-only feature     | Unit + Integration                 |
| FE-only feature     | Unit + Integration                 |
| Cross-stack feature | Unit + Integration (both stacks)   |
| Bug fix (any)       | Regression test in affected stack  |
| Hotfix              | Minimal regression test            |

---

## Quick Reference

### Commands

```bash
/plan [ticket]                  # Plan feature (creates branch + plan file)
/implement plans/task.md        # Implement from plan
/implement "description"        # Implement simple task (no plan)
/fix [ticket or description]    # Fix bug
/review                         # Code review
/commit                         # Commit + PR + update Notion
```

### Decision tree

```
  New task arrives
       │
       ▼
  Production emergency? ──YES──▶ Case 5: hotfix/TICKET/slug
       │                          /fix → /review → /commit
       NO                         → immediate deploy
       │
       ▼
  Is it a bug? ──YES──▶ Cross-stack? ──YES──▶ Case 4: investigate
       │                    │                   → handoff to root cause repo
       NO                   NO
       │                    │
       ▼                    ▼
  Simple (1-2 files)?    Case 3: /fix → /review → /commit
       │
  YES──▶ Case 6: /implement "desc" → /review → /commit
       │
       NO
       │
       ▼
  Cross-stack? ──YES──▶ Case 2: BE /plan → /impl → /commit
       │                          FE /plan → /impl → /commit
       NO
       │
       ▼
  Case 1: /plan → /implement → /review → /commit
```

---

## Agents Reference

### Team Agents

| Agent         | Model  | Purpose                                                      |
| ------------- | ------ | ------------------------------------------------------------ |
| code-reviewer | sonnet | Review diff against standards and stack-rules.md             |
| tester        | haiku  | Run tests, analyze failures, report coverage                 |
| debugger      | sonnet | Investigate bugs with root cause analysis, check logs/DB     |

### CK Agents

| Agent               | Model  | Purpose                                              |
| ------------------- | ------ | ---------------------------------------------------- |
| planner             | sonnet | Research codebase, create phased implementation plans |
| researcher          | haiku  | Technical research, evaluate trade-offs (read-only)  |
| fullstack-developer | sonnet | Execute plan phases with strict file ownership        |
| docs-manager        | haiku  | Update project docs to match codebase                |
| code-simplifier     | opus   | Simplify code without changing behavior              |
| project-manager     | sonnet | Track progress, update plans, coordinate             |
| ui-ux-designer      | sonnet | UI/UX design, wireframes, responsive layouts         |

## Skills Reference

### Workflow Skills

| Skill    | Command      | Purpose                                            |
| -------- | ------------ | -------------------------------------------------- |
| plan     | `/plan`      | Read ticket → analyze → create branch + plan       |
| implement| `/implement` | Follow plan, write code, run tests                 |
| fix      | `/fix`       | Reproduce → debug → fix → regression test          |
| review   | `/review`    | Code quality check + code-reviewer agent           |
| commit   | `/commit`    | Commit → push → create PR → update Notion          |

### Shared Skills

| Skill               | Purpose                                          |
| -------------------- | ------------------------------------------------ |
| docs-seeker          | Search library/framework docs via context7.com   |
| sequential-thinking  | Step-by-step analysis with revision capability   |
| problem-solving      | Systematic techniques when stuck                 |
| research             | Research technical solutions and architectures   |
| brainstorm           | Trade-off analysis with brutal honesty           |
| preview              | Visual explanations, slides, diagrams            |
| mermaidjs-v11        | Mermaid.js v11 diagrams                          |
| scout                | Fast parallel codebase search                    |
| debug                | Systematic debugging with root cause analysis    |
| git                  | Git operations with conventional commits         |
| ai-multimodal        | Analyze images/audio/video via Gemini API        |

### Stack-Specific Skills

**NestJS:** backend-development, databases
**Next.js:** frontend-development, web-frameworks, react-best-practices, ui-styling, web-testing
**React Native:** mobile-development

## Rules

| Rule                 | Loaded | Purpose                                                    |
| -------------------- | ------ | ---------------------------------------------------------- |
| development-rules.md | Always | YAGNI/KISS/DRY, code quality, pre-commit, git conventions  |
| stack-rules.md       | Always | Stack patterns, commands, review checklist, test/debug      |

## Required MCPs

| MCP      | Purpose                                | Required    |
| -------- | -------------------------------------- | ----------- |
| Notion   | Read tickets, update status/checklists | Yes         |
| Context7 | Look up library/framework docs         | Recommended |
