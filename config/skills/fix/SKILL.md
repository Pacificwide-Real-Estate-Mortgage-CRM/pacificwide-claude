---
name: fix
description: 'Fix bugs by reproducing, debugging, fixing, and testing. Use for bug fix tickets. Use: /fix [Notion ticket link or bug description]'
---

# /fix - Bug Fix

Fix bugs by reproducing the issue, finding root cause, implementing fix, and preventing regression.

**Input:** Notion ticket link or bug description via `$ARGUMENTS`

## When to use /fix vs /implement

- **Use /fix**: Bug reports, production issues, error fixes, incorrect behavior, performance issues
- **Use /implement**: New features, enhancements, new endpoints, schema changes (even if they fix a limitation)

## Workflow

### Step 1: Read the bug ticket

If `$ARGUMENTS` contains a Notion link:
- Use Notion MCP to read the ticket properties and description
- Look for: bug description, steps to reproduce, expected vs actual behavior, error messages
- Read any linked documents or related tickets
- **Images/Screenshots:** Notion MCP may not be able to read images. If the ticket mentions screenshots or you see image references:
  - Ask the user: "I see the ticket has screenshots/images attached. Please share them so I can see the error/bug visually."
  - Wait for user to attach images before proceeding
- If Notion MCP is unavailable, ask the user to paste the ticket content

If `$ARGUMENTS` is just a description:
- Use that as the bug description
- Ask user for reproduction steps if not clear
- If bug is visual (UI issue, wrong display), ask user to attach screenshot

**Critical information needed:**
- What is the expected behavior?
- What is the actual (buggy) behavior?
- How to reproduce it (exact steps)?
- Any error messages or stack traces?
- Screenshots (if the bug is visual or shows an error)

**If any critical information is missing:** Ask user before proceeding.

---

### Step 2: Read project context and locate the bug

- Read `docs/code-standards.md`, `docs/codebase-summary.md`, and `.claude/rules/stack-rules.md` for project context
- Identify which module/files are likely involved based on the bug description
- Use Grep to search for relevant error messages, function names, or endpoints mentioned in the bug report
- Read the suspected files to understand current implementation

---

### Step 3: Reproduce the bug

**Attempt to reproduce locally:**

**For API bugs:** Use curl or API client to reproduce the request
**For database bugs:** Query the database directly to check state
**For UI bugs:** Reproduce in browser/simulator
**For test failures:** Run the specific failing test

Use commands from `.claude/rules/stack-rules.md` for stack-specific tools.

**Document reproduction:**
- Did you successfully reproduce it? (Yes/No)
- If yes: what were the exact steps and what did you observe?
- If no: what's different from the bug report? (environment, data, timing)

**If you cannot reproduce:** Report to user and ask for clarification before proceeding.

---

### Step 4: Debug and find root cause

Use the `debugger` agent to investigate:

```markdown
Debug the following issue:

**Bug:** [description from ticket]

**Reproduction steps:** [what you did in Step 3]

**Observed behavior:** [actual result]

**Expected behavior:** [from ticket]

**Files involved:** [list from Step 2]

**Error messages/logs:** [if any]

Find the root cause and explain what is causing the bug.
```

Wait for the debugger agent to return:
- Root cause explanation
- Affected code location (file:line)
- Why the bug occurs (logic error, missing validation, race condition, etc.)

---

### Step 5: Implement the fix

Based on the root cause from Step 4, implement the fix:

**Read the affected file(s) first:**
- Understand the current logic and surrounding code
- Check for similar patterns elsewhere in the codebase

**Implement the fix:**
- Make the minimal change needed to fix the bug (KISS principle)
- Preserve existing behavior for non-buggy cases
- Add input validation if the bug was caused by invalid data
- Add error handling if the bug was an unhandled exception
- Follow project patterns (workspace filtering, transactions, error handling)

**Common fix patterns:**
- Missing null checks: Add guards for nullable values
- Missing input validation: Add proper validation
- Logic errors: Fix conditionals or calculations
- Missing error handling: Add try-catch blocks
- Stack-specific patterns: See `.claude/rules/stack-rules.md` → "Debug Patterns"

---

### Step 6: Write regression test

**Critical:** Add a test to prevent this bug from reoccurring.

Check if a relevant test file exists for the affected module.

If test file exists, add a new test case:
- Test name should describe the bug: `it('should handle null workspace owner', ...)`
- Test should reproduce the buggy scenario
- Test should assert the expected (correct) behavior

If no test file exists, create one following existing patterns in the module.

**Test structure:**
```typescript
describe('Bug fix: [brief description]', () => {
  it('should [expected behavior] when [bug scenario]', async () => {
    // Arrange: set up the buggy scenario
    // Act: call the method/component that had the bug
    // Assert: verify it now behaves correctly
  });
});
```

---

### Step 7: Verify the fix

Run build/lint/test commands from `.claude/rules/stack-rules.md`.

**Verify the specific fix:**
- Re-run the reproduction steps from Step 3
- Confirm the bug no longer occurs
- Confirm expected behavior now happens

**If tests fail:**
- Read the failure message
- Determine if the fix broke something else or if the test needs updating
- Use `debugger` agent if stuck after 2 attempts

Do NOT proceed until all checks pass and the bug is verified fixed.

---

### Step 8: Update Notion ticket

If the ticket is from Notion:
- Use Notion MCP to add a comment with:
  - Root cause explanation (from Step 4)
  - What was changed to fix it
  - Regression test added (file path)
- Set ticket status to "Ready for Review" or "Fixed"
- If status field differs, report to user

If no Notion ticket, skip this step.

---

### Step 9: Handoff

Print summary:
```markdown
## Bug Fix Complete

**Bug:** [brief description]
**Root cause:** [one-line explanation]
**Files changed:** [list]
**Regression test:** [file path]
**Verification:** [PASS / FAIL]

Next: /review
```

---

## Rules

- **Always reproduce first:** Never fix a bug you can't reproduce (except in rare cases like race conditions)
- **Minimal changes:** Fix only what's broken, don't refactor unrelated code
- **Always add regression test:** Every bug fix MUST include a test that would have caught the bug
- **Root cause, not symptoms:** Fix the underlying cause, not just the visible symptom
- **Verify the fix:** Re-run reproduction steps to confirm bug is gone
- **Document in commit:** Commit message should reference bug ticket and explain what was fixed
- Use `debugger` agent for complex issues (can't find root cause after 15 minutes of investigation)
- Use `tester` agent if regression test needs more comprehensive coverage analysis
- Follow `.claude/rules/development-rules.md`
- Keep fixes simple and targeted (KISS principle)
