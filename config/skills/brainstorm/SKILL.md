---
name: ck:brainstorm
description: "Brainstorm solutions with trade-off analysis and brutal honesty. Use for ideation, architecture decisions, technical debates, feature exploration, feasibility assessment, design discussions."
license: MIT
version: 2.0.0
argument-hint: "[topic or problem]"
---

# /brainstorm — Solution Exploration

Explore solutions with brutal honesty about feasibility and trade-offs. YAGNI, KISS, DRY.

## Usage

When to use: architecture decisions, feature exploration, technical debates, feasibility assessment.

## Workflow

1. **Scout** — use `ck:scout` to find relevant files and read `docs/`
2. **Discover** — ask clarifying questions about requirements, constraints, timeline
3. **Research** — gather info from agents and external sources
4. **Analyze** — evaluate multiple approaches with pros/cons
5. **Debate** — present options, challenge preferences, work toward optimal solution
6. **Document** — create markdown summary with: problem statement, evaluated approaches, final recommendation, risks, next steps
7. **Finalize** — ask if user wants implementation plan; if yes, run `/ck:plan` with summary context

## Rules

- Present 2-3 viable solutions with clear pros/cons for every decision
- Challenge user's initial approach — best solution is often different
- Prioritize long-term maintainability over short-term convenience
- DO NOT implement anything — brainstorm and advise only
- Save report using `Report:` path from `## Naming` section
