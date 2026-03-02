# Claude Code Team Workflow

## Stacks

This config supports multiple stacks. The CLI auto-detects your stack from `package.json`:

| Stack          | Detection key    | Stack rules               |
| -------------- | ---------------- | ------------------------- |
| NestJS (BE)    | `@nestjs/core`   | `stacks/nestjs/`          |
| Next.js (FE)   | `next`           | `stacks/nextjs/`          |
| React Native   | `react-native`   | `stacks/react-native/`    |

Each stack provides:
- `stack-rules.md` — framework patterns, commands, review checklist, test/debug patterns
- `skills/` — stack-specific skills (e.g., backend-development, frontend-development)

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
│   ├── code-reviewer.md       # Reviews diff against project standards
│   ├── tester.md              # Runs tests, reports failures
│   ├── debugger.md            # Investigates bugs, finds root cause
│   ├── planner.md             # Implementation planning
│   ├── researcher.md          # Technical research
│   ├── fullstack-developer.md # Phase execution from plans
│   ├── docs-manager.md        # Documentation management
│   ├── code-simplifier.md     # Code cleanup/refactoring
│   ├── project-manager.md     # Project tracking
│   └── ui-ux-designer.md      # UI/UX design
├── rules/
│   ├── development-rules.md   # Team standards (always loaded)
│   └── stack-rules.md         # Stack-specific patterns (auto-copied)
└── skills/
    ├── plan/SKILL.md          # /plan workflow
    ├── implement/SKILL.md     # /implement workflow
    ├── fix/SKILL.md           # /fix workflow
    ├── review/SKILL.md        # /review workflow
    ├── commit/SKILL.md        # /commit workflow
    ├── docs-seeker/           # Library docs lookup
    ├── sequential-thinking/   # Systematic analysis
    ├── debug/                 # Systematic debugging
    ├── scout/                 # Fast codebase search
    ├── git/                   # Git operations
    └── ...                    # + stack-specific skills
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

## Agents Reference

### Team Agents (custom)

| Agent         | Model  | Purpose | When to use |
| ------------- | ------ | ------- | ----------- |
| code-reviewer | sonnet | Review git diff against project standards and stack-rules.md | `/review` skill, before every commit |
| tester        | haiku  | Run tests, analyze failures, report coverage | `/implement`, `/fix`, `/review` |
| debugger      | sonnet | Investigate bugs with root cause analysis, check logs/DB | `/fix` skill, when tests fail repeatedly |

### CK Agents (shared toolkit)

| Agent               | Model  | Purpose | When to use |
| ------------------- | ------ | ------- | ----------- |
| planner             | sonnet | Research codebase, create phased implementation plans | Complex features, multi-file changes |
| researcher          | haiku  | Technical research, evaluate trade-offs (no code changes) | Before planning, technology evaluation |
| fullstack-developer | sonnet | Execute implementation phases with strict file ownership | Parallel plan execution |
| docs-manager        | haiku  | Update project docs, ensure accuracy with codebase | After major feature implementations |
| code-simplifier     | opus   | Simplify code for clarity without changing behavior | After implementation, refactoring |
| project-manager     | sonnet | Track progress, update plan status, coordinate docs | Project oversight, status reports |
| ui-ux-designer      | sonnet | UI/UX design, wireframes, design system, responsive layouts | Frontend design work |

## Skills Reference

### Workflow Skills (invoked via `/command`)

| Skill        | Command      | Purpose |
| ------------ | ------------ | ------- |
| plan         | `/plan`      | Read Notion ticket + analyze codebase → create action plan in `plans/` |
| implement    | `/implement` | Follow plan checklist, write code, run tests, mark items done |
| fix          | `/fix`       | Reproduce bug → debug → fix → regression test |
| review       | `/review`    | Run project checks + code-reviewer agent → fix issues → verify |
| commit       | `/commit`    | Lint → test → stage → commit → update Notion → push |

### Shared Skills (activated automatically when needed)

| Skill               | Purpose | Example use case |
| -------------------- | ------- | ---------------- |
| docs-seeker          | Search library/framework docs via context7.com | "How does TypeORM `@ManyToOne` work?" |
| sequential-thinking  | Step-by-step analysis with revision capability | Complex debugging, multi-step reasoning |
| problem-solving      | Systematic techniques when stuck | Recurring bugs, complexity spirals |
| research             | Research technical solutions and architectures | Technology evaluation, best practices |
| brainstorm           | Trade-off analysis with brutal honesty | Architecture decisions, feature exploration |
| preview              | Generate visual explanations, slides, diagrams | Explaining code, architecture overview |
| mermaidjs-v11        | Create Mermaid.js v11 diagrams | Flowcharts, ER diagrams, sequence diagrams |
| scout                | Fast parallel codebase search | Find files, gather context quickly |
| debug                | Systematic debugging with root cause analysis | Bugs, test failures, performance issues |
| git                  | Git operations with conventional commits | Staging, PRs, auto-split commits |
| ai-multimodal        | Analyze images/audio/video via Gemini API | OCR, design extraction, video analysis |

### Stack-Specific Skills (auto-copied based on detected stack)

**NestJS:**

| Skill                | Purpose |
| -------------------- | ------- |
| backend-development  | NestJS/Node.js API patterns, REST/GraphQL, auth, microservices |
| databases            | PostgreSQL schema design, queries, migrations, indexes, optimization |

**Next.js:**

| Skill                | Purpose |
| -------------------- | ------- |
| frontend-development | React/TypeScript components, Suspense, lazy loading, performance |
| web-frameworks       | Next.js App Router, RSC, SSR/ISR, Turborepo, caching strategies |
| react-best-practices | React/Next.js performance optimization (Vercel Engineering) |
| ui-styling           | shadcn/ui components, Tailwind CSS, themes, dark mode, responsive |
| web-testing          | Playwright, Vitest, k6 — E2E, unit, integration, load, a11y testing |

**React Native:**

| Skill                | Purpose |
| -------------------- | ------- |
| mobile-development   | React Native/Flutter patterns, iOS/Android, offline-first, app store |

## Rules Reference

| Rule                 | Loaded | Purpose |
| -------------------- | ------ | ------- |
| development-rules.md | Always | YAGNI/KISS/DRY, file naming, code quality, pre-commit, git workflow |
| stack-rules.md       | Always | Stack-specific: commands, architecture, review checklist, test/debug patterns |

## Required MCPs

| MCP      | Purpose                                | Required    |
| -------- | -------------------------------------- | ----------- |
| Notion   | Read tickets, update status/checklists | Yes         |
| Context7 | Look up library/framework docs         | Recommended |
