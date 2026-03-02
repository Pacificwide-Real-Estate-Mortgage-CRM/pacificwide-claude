---
name: commit
description: "Pre-commit checks + commit + update Notion. Runs lint/test, creates conventional commit, updates ticket status. Use after /review passes."
---

# /commit - Commit Changes

Create a commit with proper checks and update Notion ticket status.

**Input:** Optional commit message via `$ARGUMENTS`, otherwise auto-generate

## Workflow

### Step 1: Verify review completed

**Check if /review was run:**
- If the previous conversation turn contains "Code Review Complete" with verdict "READY TO COMMIT", proceed
- Otherwise, ask user: "Did you run /review? I don't see a recent review output. Run /review first or confirm you want to commit without review."

**IMPORTANT:** Never commit code that hasn't been reviewed unless explicitly confirmed by user.

---

### Step 2: Verify branch safety

Check current branch:
```bash
git rev-parse --abbrev-ref HEAD
```

- **If on `master` or `main`:** STOP. Print error:
  ```
  ERROR: Cannot commit directly to master branch.
  Create a feature branch first: git checkout -b type/description
  ```
- **If on feature branch:** Proceed to verification.

---

### Step 3: Pre-commit verification

**If you just ran `/review` and verdict was "READY TO COMMIT":** Skip verification and proceed to Step 4.

**If running `/commit` standalone** (without `/review` first), verify:

Run build/lint/test commands from `.claude/rules/stack-rules.md`. Typical:
- Lint: `npm run lint:fix`
- Build: `npm run build`
- Test: `npm test`

- ALL must pass before proceeding
- If any fail: STOP and report. Run `/review` first to diagnose and fix issues.

---

### Step 4: Sync plan file

If a plan file exists in `plans/`:
1. Read the plan file
2. Mark all implemented items as complete: change `[ ]` to `[x]` for tasks that were completed
3. Keep any TODOs added by `/review` as `[ ]` (these are future work)
4. Save the updated plan file

If no plan file exists, skip this step.

---

### Step 5: Stage changes

Review all changes:
```bash
git status          # See all modified/new files
git diff            # Review unstaged content
```

Determine what belongs in THIS commit:
- **Include:** Files directly related to the commit message you'll write
- **Include:** Tests for the changed code
- **Include:** Updated DTOs/entities/migrations if schema changed
- **Include:** Plan file (if exists and was updated in Step 4)
- **Exclude:** `.env` files, credentials, `node_modules/`
- **Exclude:** Unrelated changes (typo fixes, debug logs, commented code)
- **Exclude:** WIP changes for different feature

Stage files one by one:
```bash
git add src/deal/deal-commission.service.ts
git add src/deal/dtos/commission-calculation.dto.ts
git add src/deal/deal-commission.spec.ts
git add plans/commission-calculation.md
# etc. - one file per line
```

Verify staged changes match commit intent:
```bash
git diff --cached   # Should only show changes for ONE logical change
```

If you have unrelated changes, stash them for later:
```bash
git stash push -m "WIP: other feature" -- path/to/unrelated-file.ts
```

---

### Step 6: Create commit message

**If `$ARGUMENTS` provided:** Use it as the commit message (validate it follows conventional format).

**If no `$ARGUMENTS`:** Analyze staged changes to generate message:
1. Read `git diff --cached --name-only` to see affected files
2. If plan file exists, read "## Context" section for feature description
3. Determine commit type from changes:
   - New files in `src/`: `feat`
   - Modified files fixing bugs: `fix`
   - Only test files: `test`
   - Only docs: `docs`
   - Refactoring: `refactor`
4. Determine scope from module path (e.g., `src/deal/` → scope is `deal`)
5. Write concise description (under 72 chars) describing WHAT changed, not HOW

Validate message:
- Format: `type(scope): description`
- Types: feat, fix, docs, refactor, test, ci, chore, perf
- Subject under 72 characters
- Imperative mood ("add" not "added", "fix" not "fixed")

**Deployment tags (optional):**
- Add `[deploy]` prefix or suffix if commit should trigger immediate deployment:
  - `[deploy] fix: critical payment encryption bug`
  - `feat: add SMS templates [deploy]`
- Only use for: hot-fixes, critical features, production issues

Create commit with Co-Authored-By footer:
```bash
git commit -m "$(cat <<'EOF'
feat(deal): add commission calculation for team leads

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

---

### Step 7: Update Notion (if ticket exists)

If plan file has a Notion ticket link:
1. Use Notion MCP to read ticket's status field name and available options
2. Attempt to update status to "Ready for Review" or "Done"
3. **If field name or options differ:** Report to user instead of guessing:
   ```
   Commit successful. Could not auto-update Notion ticket.
   Status field options: [list actual options]
   Please update manually to: [appropriate status]
   ```
4. Add comment to ticket: "Committed in [commit hash]: [commit message]"

If no ticket link in plan file, skip this step.

---

### Step 8: Push to remote (optional)

Ask user:
```
Commit created successfully. Do you want to push to remote now? (y/n)
```

**If yes:**
```bash
# If branch already tracks remote
git push origin $(git rev-parse --abbrev-ref HEAD)

# If branch doesn't track remote yet (first push)
git push -u origin $(git rev-parse --abbrev-ref HEAD)
```

**If no:**
```
You can push later with: git push origin <branch-name>
```

---

### Step 9: Success output

Print confirmation:
```markdown
## Commit Complete

**Branch:** [branch-name]
**Commit:** [commit hash and message]
**Notion:** [Updated ticket #123 / No ticket linked / Update failed - see above]
**Pushed:** [Yes / No]

**Next steps:**
- Continue working: Make more changes and repeat /plan → /implement → /review → /commit
- Create PR: Run `gh pr create` or use GitHub UI
- Switch context: `git checkout other-branch`
```

---

## Rules

- NEVER commit if lint, build, or tests fail
- NEVER commit `.env` files, API keys, database credentials, or secrets
- NEVER use `git add .` or `git add -A` - add specific files
- NEVER commit directly to `master` or `main` branch
- ALWAYS include Co-Authored-By footer with Claude model version
- One commit per logical change, not one giant commit
- Keep commits focused on actual code changes (no unrelated formatting/refactors unless that's the commit's purpose)
- Follow `.claude/rules/development-rules.md` for git conventions
