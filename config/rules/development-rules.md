# Development Rules

**Stack-specific rules:** Read `.claude/rules/stack-rules.md` for framework patterns, commands, and architecture specific to your project.

**IMPORTANT:** You ALWAYS follow these principles:

1. YAGNI (You Aren't Gonna Need It)

- Avoid over-engineering and premature optimization
- Implement features only when needed
- Don't build infrastructure for hypothetical future requirements
- Start simple, refactor when necessary

2. KISS (Keep It Simple, Stupid)

- Prefer simple, straightforward solutions
- Avoid unnecessary complexity
- Write code that's easy to understand and modify
- Choose clarity over cleverness

3. DRY (Don't Repeat Yourself)

- Eliminate code duplication
- Extract common logic into reusable functions/modules
- Use composition and abstraction appropriately
- Maintain single source of truth

## General

- **File Naming**: kebab-case with descriptive names (e.g., `deal-commission-calculation.service.ts`)
- **File Size**: Keep files under 500 lines. Split into service/controller/dto/entity
- Use `gh` bash command for GitHub operations
- Use `psql` bash command to query PostgreSQL for debugging
- Use Context7 MCP for looking up library/framework documentation
- **[IMPORTANT]** Follow existing patterns in the codebase
- **[IMPORTANT]** Implement real code, never mock or simulate

## Code Quality Guidelines

- Prioritize functionality and readability over strict style enforcement
- Ensure no syntax errors and code compiles (`npm run build`)
- Use try-catch error handling and follow security standards
- After implementation, use `/review` skill to verify code quality

## Pre-commit/Push Rules

- Run `npm run lint:fix` before commit
- Run `npm test` before push (DO NOT ignore failed tests)
- Keep commits focused on actual code changes
- **DO NOT** commit `.env` files, API keys, database credentials, or secrets
- Use conventional commit format: `type(scope): description`

## Code Implementation

- Write clean, readable, and maintainable code
- Follow established architectural patterns in your stack
- Handle edge cases and error scenarios
- **DO NOT** create new enhanced/v2 files, update existing files directly

## Naming Conventions

- **Variables/Functions**: camelCase
- **Classes**: PascalCase
- **Constants**: UPPER_SNAKE_CASE
- **Files**: kebab-case (e.g., `user-profile.service.ts`)
- **DB columns**: snake_case
- **API endpoints**: kebab-case, plural nouns (`/api/deal-agents/:id`)

## Git Conventions

- **Branch**: `type/description` (e.g., `feature/oauth-login`, `fix/deal-calculation`)
- **Commit types**: feat, fix, docs, refactor, test, ci, chore, perf
- **Commit format**: `type(scope): description`
- Do NOT include Co-Authored-By or AI references in commits

## Team Workflow

Use these skills for consistent workflow across the team:

**For new features:**
1. `/plan` - Plan tasks from Notion tickets (medium/large tasks)
2. `/implement` - Implement features following standards
3. `/review` - Review code quality before commit
4. `/commit` - Lint, test, commit, update Notion

**For bug fixes:**
1. `/fix` - Reproduce, debug, fix, test bug
2. `/review` - Review code quality before commit
3. `/commit` - Lint, test, commit, update Notion
