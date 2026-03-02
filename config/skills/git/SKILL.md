---
name: ck:git
description: "Git operations with conventional commits. Use for staging, committing, pushing, PRs, merges. Auto-splits commits by type/scope. Security scans for secrets."
argument-hint: "cm|cp|pr|merge [args]"
version: 1.0.0
---

# /git — Git Operations

Commit, push, PR, merge with conventional commits and secret scanning.

## Usage

- `cm` — stage files + create commits
- `cp` — stage, commit, and push
- `pr [to-branch] [from-branch]` — create Pull Request (default: main ← current)
- `merge [to-branch] [from-branch]` — merge branches (default: main ← current)

No arguments: present options via `AskUserQuestion`.

## Workflow

```bash
# 1. Stage + analyze
git add -A && git diff --cached --stat && git diff --cached --name-only

# 2. Security scan
git diff --cached | grep -iE "(api[_-]?key|token|password|secret|credential)"
# If secrets found: STOP, warn user, suggest .gitignore

# 3. Commit
git commit -m "type(scope): description"
```

## Split vs Single Commit

- **Split** if: different types mixed (feat+fix), multiple scopes, config+code mixed, >10 unrelated files
- **Single** if: same type/scope, ≤3 files, ≤50 lines

## Rules

- Conventional commits: `feat`, `fix`, `perf`, `docs`, `refactor`, `test`, `chore`
- For `.claude` directory files: only use `feat`, `fix`, or `perf` (not `docs`)
- Search GitHub for related issues; add to PR body
- Never force-push to main/master
- Load `references/` for detailed workflow guidance
