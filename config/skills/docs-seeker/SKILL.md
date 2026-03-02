---
name: ck:docs-seeker
description: Search library/framework documentation via llms.txt (context7.com). Use for API docs, GitHub repository analysis, technical documentation lookup, latest library features.
version: 3.1.0
argument-hint: "[library-name] [topic]"
---

# /docs-seeker — Documentation Discovery

Search library docs via context7.com scripts. No manual URL construction needed.

## Usage

When to use: API docs lookup, library features, GitHub repo analysis, version-specific docs.

## Workflow

Run scripts in order:

```bash
# 1. Detect query type
node scripts/detect-topic.js "<user query>"

# 2. Fetch documentation
node scripts/fetch-docs.js "<user query>"

# 3. Analyze if multiple URLs returned
cat llms.txt | node scripts/analyze-llms-txt.js -
```

## Scripts

- `detect-topic.js` — Classifies query, extracts library + topic, returns `{topic, library, isTopicSpecific}`
- `fetch-docs.js` — Constructs context7.com URLs, handles fallback chain, outputs llms.txt content
- `analyze-llms-txt.js` — Categorizes URLs, recommends agent distribution strategy

## Rules

- Always run scripts in order; never construct URLs manually
- For general queries (8+ URLs): deploy parallel agents per script recommendation
- For topic queries (2-3 URLs): read directly with WebFetch
- Environment: `.env` loaded from `$HOME/.claude/skills/docs-seeker/.env` or `$HOME/.claude/.env`
