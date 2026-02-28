---
name: plan
description: 'Plan a task from Notion ticket. Reads ticket, analyzes codebase, creates action plan. Use for medium/large tasks.'
---

# /plan - Task Planning

Plan implementation from a Notion ticket or task description.

**Input:** Notion ticket link or task description via `$ARGUMENTS`

## When to use /plan vs just /implement

- **Skip /plan** (use `/implement` directly): single file change, bug fix, simple CRUD, config tweak
- **Use /plan**: 2-5 files affected, new entity, new service, cross-module changes
- **Use /plan and split into phases**: 6+ files, new module, multiple entities, queue/scheduler, needs multiple PRs

## Workflow

### Step 1: Read the ticket and spec document

- Use Notion MCP to read the ticket properties and description
- **Read the linked Document** (the "Document" property on the ticket) - this is the detailed spec containing:
  - Functional description and use cases
  - Database schema (new tables, modified columns)
  - Business rules, permission rules, process rules
  - Status definitions and acceptance criteria
- **Images/Diagrams:** Notion MCP may not be able to read images. If the spec document mentions diagrams, flowcharts, or UI mockups:
  - Ask the user: "I see the spec has diagrams/images. Please share them so I can understand the design visually."
  - Wait for user to attach images before proceeding
- Also read the parent task description if it exists for broader context
- If no Notion link provided, use the `$ARGUMENTS` as task description
- If Notion MCP is unavailable, ask the user to paste the ticket and spec content directly
- **If ticket has no linked Document or spec lacks DB schema/use cases/acceptance criteria**: flag as blocker in Step 3

### Step 2: Analyze the codebase

- Read `docs/code-standards.md` and `docs/codebase-summary.md` for project context
- Read relevant existing files that will be affected
- Understand current patterns and architecture
- Identify which modules/files need changes
- Check for existing similar implementations to follow as reference
- **Trace dependencies**: check what imports/consumes the files you plan to change (DTOs, controllers, tests that reference modified entities)

### Step 3: Flag unclear or missing details

After reading BOTH the spec AND the codebase, check for:
- **Ambiguous requirements**: vague descriptions, conflicting use cases, undefined behavior
- **Missing information**: no DB schema, missing field types/constraints, unclear permission rules
- **Assumptions needed**: edge cases not covered, integration points not specified, error handling not defined
- **Conflicts with existing codebase**: spec suggests patterns that differ from current architecture
- **Missing spec**: ticket has no Document or Document lacks structure - this is a **blocker**

**If any concerns found**: STOP and ask the user before proceeding. List all questions clearly.
**If everything is clear**: Proceed to create the plan. Note any minor assumptions in the plan's "Key decisions" section.

### Step 4: Create the plan file

Save to `plans/[brief-task-name].md` (e.g., `plans/sms-follow-up-reminder.md`).
Create the `plans/` directory if it does not exist.
Also display the plan in the conversation for immediate review.

**Plan file format:**

```markdown
# Plan: [task title]

**Ticket:** [link if provided]
**Spec:** [link to Document or local file path if available]
**Branch:** `type/description`
**Scope:** [list of modules affected]
**Created:** [date]

## Context

[Brief summary: what this feature does, why, key user flows]

## Database changes

For each table change, inline the exact field definitions from the spec:

- [ ] **Migration** `YYYYMMDD-description`: [what tables/columns to add or modify]
  - `column_name` type NULL/NOT NULL default - description
  - `column_name` type NULL/NOT NULL default - description
- [ ] **Entity** `src/path/entity.ts`: [create or modify, list fields matching migration]

## New files

- [ ] `src/path/file.ts`: [purpose and what it contains]
- [ ] ...

## Modified files

- [ ] `src/path/file.ts`: [what to change and why]
- [ ] ...

## Implementation order

1. Database: migration + entity (must be first)
2. Service: business logic
3. Controller + DTOs: API endpoints
4. [Queue/Scheduler/Webhook if applicable]
5. Register in module + app.module.ts
6. Tests

## API changes (if any)

- [ ] `METHOD /website/api/v1/endpoint` - [description, request/response shape, auth required]
- [ ] ...

## Business rules to enforce

- [inline key rules from spec that affect implementation logic, with enough detail to implement]

## Tests

- [ ] `src/path/file.spec.ts`: [what to test — key business logic, edge cases, error paths]
- [ ] ...

## Key decisions

- [architectural decisions, trade-offs, assumptions made]

## Risks

- [potential issues to watch for]
```

### Step 5: Update Notion (if ticket provided)

- Use Notion MCP to add the plan file path as a comment on the ticket
- Set ticket status to "In Progress"
- If status field name or options differ from expected, report to user instead of guessing

### Step 6: Handoff

Print the exact command for the next step:
```
Next: /implement plans/[task-name].md
```

## Rules

- Keep plans simple and actionable - one file, not a folder structure
- Each checklist item should be a clear, executable task
- Include specific file paths, not vague descriptions
- **Inline critical details from the spec**: field names, types, enums, validation rules, constraints. The plan must be implementable without re-reading the full spec
- When no Notion ticket exists, the plan must be fully self-contained (include task description and acceptance criteria in Context section)
- Map spec's use cases to concrete implementation tasks
- Include DB schema changes with exact column definitions
- Include key business/permission rules with enough detail to implement
- Follow `.claude/rules/development-rules.md`
- DO NOT implement code - only create the plan file
- DO NOT include code examples, snippets, or pseudocode in the plan. Describe WHAT to do, not HOW to code it
- Do not create, modify, or scaffold any source files in `src/` or `migrations/`
- Plan files should be committed to git on the feature branch. Delete after feature is merged
- Plan file name should be short and descriptive (kebab-case)
