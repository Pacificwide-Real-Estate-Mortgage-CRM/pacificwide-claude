---
name: review
description: "Code quality review by code-reviewer agent. Use after /implement, before /commit. Assumes lint/build/test already passed."
---

# /review - Code Quality Review

Review code quality and architecture against team standards. Assumes `/implement` already verified compilation and tests.

**Input:** Optional path filter via `$ARGUMENTS` (e.g., `/review src/deal/` to review only deal module)

## Workflow

### Step 1: Determine scope and gather changes

Collect uncommitted changes:
```bash
git status                    # Overview
git diff --name-only          # Unstaged files
git diff --cached --name-only # Staged files
```

If `$ARGUMENTS` provided (e.g., `src/deal/`), filter to that path:
```bash
git diff --name-only | grep "^${ARGUMENTS}"
```

If no files match the scope, report: "No changes found in ${ARGUMENTS}" and exit.

---

### Step 2: Project-specific pre-flight checks

**Migration review (if `migrations/` changed):**
```bash
ls -t migrations/*.ts | head -1  # Find latest migration
```
Read the migration file and check:
- [ ] SQL matches entity column changes (compare with changed entity files)
- [ ] No `DROP COLUMN` without data migration script
- [ ] Indexes created for all foreign keys
- [ ] Enum changes use proper TypeORM migration syntax

**Test coverage (if `src/` changed):**
- For each new `.service.ts`, check if corresponding `.spec.ts` exists
- If missing, note in review output: "Missing test file: X.spec.ts"

**Swagger completeness (if DTOs or controllers changed):**
```bash
grep -L "@ApiProperty" src/changed-module/dtos/*.dto.ts
```
- List any DTO files without `@ApiProperty` decorators
- Check controllers for `@ApiOperation` on new endpoints

Report pre-flight findings in Step 6 output.

---

### Step 3: Dispatch code-reviewer agent

Gather the diff context:
```bash
git diff HEAD > /tmp/review-diff.txt
```

Provide this context to the code-reviewer agent:

```markdown
Review the following changes against `.claude/rules/development-rules.md`.

**What was implemented:**
[Read from plan file "## Context" or use $ARGUMENTS as summary. Example: "Added commission calculation service for deal agents"]

**Changed files:**
[List from Step 1]

**Full diff:**
[Paste contents of /tmp/review-diff.txt]

**Note:** These are uncommitted changes (not yet in git history). Review the diff provided above, not `git diff HEAD~1`.
```

Wait for the code-reviewer agent to return its structured review (Critical/High/Medium issues + Verdict).

---

### Step 4: Act on review findings

For each issue category:

**Critical issues (security, data loss, breaking changes):**
- Fix immediately using Edit/Write tools
- After fixing, mark the issue as resolved

**High priority (error handling, performance, type safety):**
- Fix before proceeding
- After fixing, mark the issue as resolved

**Medium priority (code smells, naming, validation):**
- Fix if straightforward (under 5 minutes)
- Otherwise, add to plan file as `[ ] TODO: [description]` for next session

**Update plan file:**
- If a plan file exists in `plans/`, mark any newly completed items with `[x]`
- If you added error handling and plan had "[ ] Add error handling", update to "[x] Add error handling"

---

### Step 5: Verify fixes (iteration loop)

After applying fixes from Step 4, verify:
```bash
npm run lint:fix && npm run build && npm test
```

**Iteration rules:**
- **If all pass:** Proceed to Step 6 (Output)
- **If build fails:** Read the compiler error, fix it, re-run this step (max 2 attempts)
- **If tests fail:** Determine if test needs updating for new behavior or if code has a bug. Fix, then re-run this step (max 2 attempts)
- **If lint has unfixable errors:** Report them in Step 6 and mark verdict as NEEDS FIXES

**If unable to resolve after 2 iterations:**
- Report the error output to the user
- Mark verdict as NEEDS MANUAL ATTENTION
- Stop (do NOT proceed to /commit)

---

### Step 6: Output

Print review summary:

```markdown
## Code Review Complete

**Scope:** [all changes / filtered to $ARGUMENTS]

**Pre-flight Checks:**
- Migrations: [PASS / issues found]
- Test coverage: [X of Y services have tests]
- Swagger docs: [COMPLETE / missing in: file.dto.ts]

**Code Review (from code-reviewer agent):**
- Critical issues: [count] (all fixed / [N] remaining)
- High priority: [count] (all fixed / [N] remaining)
- Medium priority: [count] ([N] fixed, [M] deferred to plan file)

**Verification After Fixes:**
- Lint: [PASS / FAIL - details]
- Build: [PASS / FAIL - details]
- Tests: [PASS / FAIL - X passed, Y failed]

**Issues Fixed:**
- [Bulleted list of what was changed]

**Remaining Issues:**
- [Any issues requiring manual attention]

**Verdict:** [READY TO COMMIT / NEEDS FIXES / NEEDS MANUAL ATTENTION]
```

If verdict is READY TO COMMIT, print:
```
Next: /commit
```

Otherwise, print the blocking issues and stop.

---

## Rules

- **Trust `/implement`:** Do NOT re-run lint/build/test unless you made fixes in Step 4
- **Evidence before claims:** Read actual code and command output, never assume
- **Agent context:** Provide the full diff to code-reviewer agent (it cannot access uncommitted changes via git commands)
- **Fix iteration limit:** Max 2 attempts per check type (build/test) before reporting to user
- **Plan file sync:** Update progress after fixes, maintain single source of truth
- **Workspace isolation check:** Verify queries filter by `workspaceOwner` (personal or team context)
- Follow `.claude/rules/development-rules.md`
