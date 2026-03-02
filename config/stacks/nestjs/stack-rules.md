# NestJS Stack Rules

## Stack

- **Framework**: NestJS 10 (TypeScript)
- **ORM**: TypeORM with PostgreSQL
- **Cache**: Redis (`@liaoliaots/nestjs-redis`)
- **Queue**: Bull (`@nestjs/bull`)
- **Auth**: JWT + Passport
- **Testing**: Jest
- **Linter**: ESLint + Prettier
- **API Docs**: Swagger (`@nestjs/swagger`)

## Commands

```bash
npm run build        # Compile TypeScript — run after every implementation
npm run lint:fix     # Fix lint issues — run before commit
npm test             # Run full test suite — run before push
npm test --runInBand # Full suite sequentially (CI-safe)
npm run test:cov     # Run with coverage report
npm run migration:generate --name=DescriptiveName  # Generate TypeORM migration
```

## Architecture Patterns

**Module structure:** `controller -> service -> entity -> dto`

**Implementation order for new modules:**

1. Migration — generate with `npm run migration:generate`, review SQL
2. Entity — TypeORM entity extending `CRMBaseEntity`
3. DTOs — Input validation with class-validator + Swagger decorators
4. Service — Business logic, extends `AbstractTransactionService` for writes
5. Controller — Routes, guards, Swagger decorators
6. Module — Register entity, providers, imports, exports
7. App module — Import new module in `app.module.ts`
8. Queue/Scheduler — Bull processor if applicable

**Module registration:**

```typescript
@Module({
  imports: [TypeOrmModule.forFeature([EntityName])],
  controllers: [EntityController],
  providers: [EntityService],
  exports: [EntityService],
})
export class EntityModule {}
```

## Security

**All authenticated controllers require guards:**

```typescript
@UseGuards(AuthGuard, UserPermissionGuard)
@Permissions(PermissionEnum.X)
@ApiBearerAuth()
```

**Workspace isolation — CRITICAL (GDPR compliance):**

Every query MUST filter by `workspaceOwner`. Use `@WorkspaceOwner()` decorator in controller to extract context and pass to service.

```typescript
// GOOD: Filter by workspace
async findAll(workspaceOwner: WorkspaceOwnerDto): Promise<Deal[]> {
  return this.dealRepository.find({
    where: { workspaceOwner: workspaceOwner.workspaceOwner }
  });
}

// BAD: Returns all data across workspaces (CRITICAL — GDPR violation)
async findAll(): Promise<Deal[]> {
  return this.dealRepository.find();
}
```

Workspace format: personal `p-{userId}` or team `t-{teamOwnerId}`.

Use `@Public()` only for unauthenticated endpoints.

## Implementation Patterns

**Entity — always extend `CRMBaseEntity`:**

```typescript
@Entity('table_name')
export class DealEntity extends CRMBaseEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'snake_case_column' })
  camelCaseProperty: string;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  amount: number;

  @ManyToOne(() => RelatedEntity)
  @JoinColumn({ name: 'related_entity_id' })
  relatedEntity: RelatedEntity;
}
```

**DTO — every field needs `@ApiProperty` or `@ApiPropertyOptional`:**

```typescript
export class CreateDealDto {
  @ApiProperty({ description: 'Deal name' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiPropertyOptional({ description: 'Optional amount' })
  @IsOptional()
  @IsNumber()
  amount?: number;

  @ApiProperty({ type: () => NestedDto })
  @ValidateNested()
  @Type(() => NestedDto)
  nested: NestedDto;
}
```

Separate `CreateXDto` and `UpdateXDto`.

**Service — extend `AbstractTransactionService` for multi-table writes:**

```typescript
@Injectable()
export class DealService extends AbstractTransactionService {
  constructor(
    @InjectRepository(DealEntity)
    private readonly dealRepository: Repository<DealEntity>,
  ) {
    super();
  }

  async createWithAgents(dealData, agents) {
    return this.executeInTransaction(async (manager) => {
      const deal = await manager.save(DealEntity, dealData);
      await manager.save(DealAgentEntity, { dealId: deal.id, agents });
      return deal;
    });
  }
}
```

Use `@Inject(forwardRef(() => Service))` for circular dependencies.

**Controller — Swagger + guards on every endpoint:**

```typescript
@ApiTags('deals')
@ApiBearerAuth()
@UseGuards(AuthGuard, UserPermissionGuard)
@Controller('deals')
export class DealController {
  @Post()
  @Permissions(PermissionEnum.CREATE_DEAL)
  @ApiOperation({ summary: 'Create a deal' })
  @ApiResponse({ status: 201, type: DealResponseDto })
  @UseInterceptors(LogAgentActivityInterceptor)
  @LogAgentActivity({ action: 'create', entity: 'deal' })
  async create(
    @WorkspaceOwner() workspaceOwner: WorkspaceOwnerDto,
    @Body() dto: CreateDealDto,
  ): Promise<DealResponseDto> {
    return this.dealService.create(workspaceOwner, dto);
  }
}
```

## Activity Logging

Add `@LogAgentActivity` interceptor to all write endpoints (create, update, delete):

```typescript
@UseInterceptors(LogAgentActivityInterceptor)
@LogAgentActivity({ action: 'create', entity: 'deal' })
@Post()
async create(...) {}

@UseInterceptors(LogAgentActivityInterceptor)
@LogAgentActivity({ action: 'update', entity: 'deal' })
@Patch(':id')
async update(...) {}

@UseInterceptors(LogAgentActivityInterceptor)
@LogAgentActivity({ action: 'delete', entity: 'deal' })
@Delete(':id')
async remove(...) {}
```

Read-only endpoints (`GET`) do not need `@LogAgentActivity`.

## Code Review Checklist

| Area | Check |
| --- | --- |
| Structure | NestJS patterns: controller -> service -> entity -> dto |
| Types | TypeScript strict, no `any` unless justified |
| Errors | try-catch on all async operations, proper NestJS exceptions |
| Security | No hardcoded secrets, input validation, parameterized queries |
| Performance | No N+1 queries, proper QueryBuilder, Redis caching |
| File size | Under 500 lines |
| Naming | kebab-case files, camelCase vars, PascalCase classes |
| **Workspace** | **All queries filter by `workspaceOwner` (p-{userId} or t-{teamId})** |
| **Base Entity** | **Entities extend `CRMBaseEntity`** |
| **Transactions** | **Multi-table writes use `executeInTransaction`** |
| **Audit Trail** | **Write endpoints use `@LogAgentActivity` interceptor** |
| **Decorators** | **Controllers extract workspace with `@WorkspaceOwner()` decorator** |
| **Swagger** | **All DTO fields have `@ApiProperty`, all endpoints have `@ApiOperation` + `@ApiResponse`** |
| **Migrations** | **Migration SQL matches entity columns exactly (types, names, indexes)** |

**N+1 query:**

```typescript
// BAD: N queries for N deals
const deals = await this.dealRepository.find();
for (const deal of deals) {
  const pipeline = await this.pipelineRepository.findOne(deal.pipelineId);
}

// GOOD: Eager load with join
const deals = await this.dealRepository.find({ relations: ['pipeline'] });
```

**Missing transaction:**

```typescript
// BAD: Orphaned deal if second save fails
async createDealWithAgents(dealData, agents) {
  const deal = await this.dealRepository.save(dealData);
  await this.dealAgentRepository.save({ dealId: deal.id, agents });
}

// GOOD: Atomic write
async createDealWithAgents(dealData, agents) {
  return this.executeInTransaction(async (manager) => {
    const deal = await manager.save(DealEntity, dealData);
    await manager.save(DealAgentEntity, { dealId: deal.id, agents });
    return deal;
  });
}
```

## Test Patterns

**Repository mocks — use proper TypeORM token:**

```typescript
// GOOD
{ provide: getRepositoryToken(DealEntity), useValue: mockDealRepository }

// BAD — won't work with @InjectRepository
{ provide: 'DealRepository', useValue: mockDealRepository }
```

**QueryBuilder mocks — all methods must be chainable:**

```typescript
// GOOD: Chainable mock
const mockQueryBuilder = {
  where: jest.fn().mockReturnThis(),
  andWhere: jest.fn().mockReturnThis(),
  leftJoinAndSelect: jest.fn().mockReturnThis(),
  getOne: jest.fn().mockResolvedValue(mockDeal),
  getMany: jest.fn().mockResolvedValue([mockDeal]),
};
mockRepository.createQueryBuilder.mockReturnValue(mockQueryBuilder);

// BAD: Non-chainable — throws "where is not a function"
mockRepository.createQueryBuilder.mockReturnValue({ where: jest.fn() });
```

**Auth guard mocks (controller tests):**

```typescript
// GOOD: Override guards so controller tests don't fail with 401
.overrideGuard(JwtAuthGuard).useValue({ canActivate: () => true })
.overrideGuard(UserPermissionGuard).useValue({ canActivate: () => true })
```

**Transaction service mocks:**

```typescript
// GOOD: Mock executes callback with manager
mockTransactionService.executeInTransaction.mockImplementation(async (callback) => {
  return callback(mockManager);
});

// BAD: Mock returns undefined — service crashes
mockTransactionService.executeInTransaction.mockResolvedValue(undefined);
```

**Workspace isolation in tests:**

```typescript
// GOOD: Assert workspace filter is applied
expect(mockRepository.find).toHaveBeenCalledWith({
  where: { workspaceOwner: 'p-user123' },
});

// BAD: Does not verify workspace filter (GDPR risk)
expect(mockRepository.find).toHaveBeenCalled();
```

**Test coverage targets:**

- Services with business logic: >70% (especially commission, loan, pipeline logic)
- Transaction-wrapped operations: >70%
- Workspace isolation filters: >70%
- Controllers: >50%
- Entities/constants: <50% acceptable

## Debug Patterns

**TypeORM gotchas (check these first):**

- Lazy relations (`Promise<T>`) accessed without `await`
- Soft delete not respected — missing `deletedAt IS NULL` or `withDeleted: false`
- QueryBuilder missing `leftJoinAndSelect` for required relations
- `save()` vs `insert()` semantics — `save()` does SELECT + INSERT/UPDATE
- Transaction-managed entities used after `queryRunner.release()`
- Circular dependency causing stack overflow — fix with `@Inject(forwardRef(() => Service))`
- TypeORM property camelCase vs DB column snake_case mismatch — use `{ name: 'snake_case' }` in `@Column`
- Migration SQL doesn't match entity columns (type or name mismatch)

**Common root causes by symptom:**

| Symptom | Likely cause |
| --- | --- |
| 500 on create/update | Missing null check after `findOne()`, or transaction not wrapping multi-table write |
| Data leak across workspaces | Missing `workspaceOwner` filter in query |
| Soft-deleted records appearing | Missing `deletedAt IS NULL` check |
| Slow endpoint | N+1 queries — use relations or QueryBuilder with joins |
| Cache returning stale data | Cache not invalidated after write operation |
| Test fails with 401 | Auth guards not mocked in controller test |
| Test fails with `where is not a function` | QueryBuilder mock methods not returning `this` |
| Test fails with `Cannot find module` | Build not run — TypeScript errors prevent test execution |

**Investigation tools:**

```bash
# Inspect database record
psql -U $DB_USER -d $DB_NAME -c "SELECT * FROM table_name WHERE id = 'xyz';"

# Inspect Redis cache
redis-cli -h $REDIS_HOST GET "cache:key"
```
