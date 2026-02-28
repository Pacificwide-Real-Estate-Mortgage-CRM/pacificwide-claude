---
name: implement
description: 'Implement from a plan file or task description. Follows NestJS patterns, runs build + tests. Use: /implement plans/task-name.md'
---

# /implement - Feature Implementation

Implement code following team standards and NestJS patterns.

**Input:** Plan file path or task description via `$ARGUMENTS`

## Workflow

### Step 1: Understand the task

- If `$ARGUMENTS` references a plan file (e.g., `plans/task-name.md`), read it
- If no plan file specified, check `plans/` for an existing plan related to the task
- If the plan references a spec document, read it for exact details (DB schema, field names, validation rules, business rules, acceptance criteria)
  - **Images/Diagrams:** If the spec mentions diagrams, UI mockups, or contains image references that Notion MCP couldn't read:
    - Ask the user: "I see the spec references diagrams/images. Please share them so I can implement the design correctly."
    - Wait for user to attach images before proceeding
- If `$ARGUMENTS` contains a Notion link, read the ticket and its linked Document via Notion MCP
  - Apply same image handling as above if spec has images
- If just a description, use that directly
- **Before starting**: check if any plan items are already marked `[x]` (from a previous session). Skip completed items

### Step 2: Read project context and existing code

- Read `docs/code-standards.md` for entity/DTO/service/controller patterns and shared utilities
- Read `docs/codebase-summary.md` for module inventory, auth architecture, and key patterns
- Identify the closest existing module to use as a reference implementation (default: `src/deal/`)
- Read the files listed in the plan's "New files" and "Modified files" sections BEFORE making changes
- Check imports, dependencies, and module registration of affected modules

### Step 3: Implement

Follow the plan's "Implementation order" if specified. Otherwise use this default order:

**Implementation order:**

1. **Migration** — Create/modify entity first, then generate with `npm run migration:generate --name=DescriptiveName` and review the generated SQL. For data migrations or enum changes, create the migration file manually in `migrations/`
2. **Entity** — TypeORM entity matching migration columns. Extend `CRMBaseEntity`
3. **DTOs** — Input validation with class-validator decorators. `@ApiProperty`/`@ApiPropertyOptional` on every field
4. **Service** — Business logic. Extend `AbstractTransactionService` and use `executeInTransaction()` for write operations touching multiple tables. Regular `@Injectable()` for read-only services
5. **Controller** — Route handling, Swagger decorators (`@ApiTags`, `@ApiOperation`, `@ApiResponse`, `@ApiBearerAuth`), auth guards, permissions
6. **Module** — Register entity in `TypeOrmModule.forFeature()`, providers, imports, exports
7. **App module** — Import new module in `app.module.ts` if this is a new module
8. **Queue/Scheduler** — If applicable, add Bull processor and register in module

**NestJS patterns:**

- Controller: `@UseGuards(AuthGuard, UserPermissionGuard)`, `@Permissions(PermissionEnum.X)`, `@WorkspaceOwner()` decorator to extract workspace context
- Service: inject repositories with `@InjectRepository(Entity)`, use `@Inject(forwardRef(() => Service))` for circular dependencies
- Entity: `@PrimaryGeneratedColumn('uuid')`, `{ name: 'snake_case' }` in `@Column` for multi-word columns, `@JoinColumn({ name: 'fk_column' })` for relations
- DTO: separate Create vs Update DTOs, `@ValidateNested` + `@Type` for nested objects
- Module: register all providers, imports, exports

**Security:**

- Validate all inputs with DTOs
- Parameterized queries (no string concatenation in SQL)
- No hardcoded secrets
- **Workspace isolation**: All data queries MUST be filtered by workspace. Accept `WorkspaceOwnerDto` from the controller (`@WorkspaceOwner()` decorator) and pass to service queries
- Use `AuthGuard` + `UserPermissionGuard` on all authenticated controllers
- Use `@Permissions(PermissionEnum.X)` on controller methods
- Use `@Public()` only for unauthenticated endpoints

**Activity logging:**

- Add `@UseInterceptors(LogAgentActivityInterceptor)` and `@LogAgentActivity({...})` on write endpoints (create, update, delete) following existing patterns in similar controllers

**Code quality:**

- try-catch on all async operations
- Proper NestJS exceptions (`NotFoundException`, `BadRequestException`, `ForbiddenException`)
- TypeScript types — no `any` unless justified
- Files under 500 lines
- kebab-case file names
- **Save progress incrementally**: After completing each checklist item from the plan, immediately mark it `[x]` in the plan file. Do NOT wait until the end

### Step 4: Write tests

- Check if the plan includes a "Tests" section — follow it
- For new services: write unit tests covering key business logic, edge cases, and error paths
- For new controllers: write tests covering endpoint routing and input validation
- Use the `tester` agent to analyze what needs test coverage if unsure
- Follow existing test patterns in the codebase (check `*.spec.ts` files in similar modules)

### Step 5: Verify

```bash
npm run lint:fix  # Fix lint issues
npm run build     # Verify compilation
npm test          # Run all tests
```

- If build fails: read the compiler error, fix the specific issue, rebuild
- If tests fail: determine if it is a code bug or a test that needs updating for the new behavior, then fix
- If you cannot resolve a build or test failure after 2 attempts: use the `debugger` agent with the error output
- Do NOT proceed until lint, build, and tests all pass

### Step 6: Update progress

- If a plan file exists in `plans/`, ensure all completed items are marked with `[x]`
- If Notion ticket exists, update the checklist via Notion MCP

### Step 7: Handoff

Print the next step:
```
Next: /review
```
Do NOT commit directly. The `/review` skill will run lint, build, tests, and dispatch the code-reviewer agent.

## Rules

- Follow `.claude/rules/development-rules.md`
- Follow the plan's "New files" and "Modified files" sections exactly. Create new files only where the plan specifies. Modify existing files where specified
- Do NOT create enhanced/v2 copies of existing files. If the plan says to modify `deal.service.ts`, modify it in place
- Implement real code, never mock or simulate
- Run build after implementation to verify compilation
- Use `debugger` agent if stuck on a complex bug (cannot resolve after 2 attempts)
- Use `tester` agent for comprehensive test analysis
- **If the task cannot be completed in one session**: Ensure all completed items are marked in the plan file, run `npm run build` to verify partial work compiles, and inform the user which items remain. The next `/implement` invocation will resume from the first unchecked item
