---
name: ck:debug
description: "Debug systematically with root cause analysis before fixes. Use for bugs, test failures, unexpected behavior, performance issues, call stack tracing, multi-layer validation, log analysis, CI/CD failures, database diagnostics, system investigation."
version: 4.0.0
languages: all
argument-hint: "[error or issue description]"
---

# /debug — Systematic Debugging

**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.**

Random fixes waste time and create new bugs. Find root cause → fix at source → validate → verify.

## Usage

- Code-level: test failures, bugs, build failures, integration problems
- System-level: server errors, CI/CD failures, performance degradation, DB issues
- Always: before claiming work complete

## Technique Dispatch

```
Code bug       → references/systematic-debugging.md (Phase 1-4)
  Deep in stack  → references/root-cause-tracing.md (trace backward)
  Found cause    → references/defense-in-depth.md (add validation layers)
  Claiming done  → references/verification.md (verify first)

System issue   → references/investigation-methodology.md (5 steps)
  CI/CD failure  → references/log-and-ci-analysis.md
  Slow system    → references/performance-diagnostics.md
  Need report    → references/reporting-standards.md

Frontend fix   → references/frontend-verification.md (Chrome/devtools)
```

## Tools

- `psql` — PostgreSQL queries
- `gh` — GitHub Actions logs
- `ck:scout` — find relevant files
- `ck:docs-seeker` — package docs
- `ck:problem-solving` — when stuck

## Rules

Stop and return to process if thinking:
- "Quick fix for now" / "Just try X" / "It's probably X" / "Should work now" / "Tests pass, done"

Iron law: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE. Run command, read output, then claim.
