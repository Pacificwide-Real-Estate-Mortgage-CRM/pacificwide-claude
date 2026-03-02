---
name: ck:research
description: "Research technical solutions, analyze architectures, gather requirements thoroughly. Use for technology evaluation, best practices research, solution design, scalability/security/maintainability analysis."
license: MIT
argument-hint: "[topic]"
---

# /research — Technical Research

Systematic research with brutal honesty. Honor YAGNI, KISS, DRY.

## Usage

When to use: technology evaluation, best practices, architecture decisions, security/performance analysis.

## Workflow

### 1. Scope Definition
- Identify key terms, recency requirements, evaluation criteria, depth boundaries

### 2. Information Gathering
- Check `$HOME/.claude/.ck.json` for `skills.research.useGemini` (default: `true`)
- If Gemini enabled: `gemini -y -m <gemini.model> "...prompt..."` (timeout: 10 min)
- If disabled: use `WebSearch` tool
- Run searches in parallel — max **5 research calls total**
- For GitHub repos found: use `ck:docs-seeker` skill

### 3. Analysis
- Identify patterns, pros/cons, maturity, security implications, compatibility

### 4. Report
- Save to `Report:` path from `## Naming` section
- Structure: Executive Summary → Key Findings → Comparative Analysis → Recommendations → Resources

## Rules

- Max 5 research tool calls — think carefully before each
- Always cite sources with links
- Sacrifice grammar for concision
- List unresolved questions at end
