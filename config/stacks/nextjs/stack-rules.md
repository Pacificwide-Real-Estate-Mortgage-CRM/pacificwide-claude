# Next.js Stack Rules

## Stack

| Layer | Library | Version |
|---|---|---|
| Framework | Next.js (App Router) | 14.2.3 |
| Language | TypeScript | 5.4.2 |
| UI | React | 18 |
| Component Library | NextUI (`@nextui-org/react`) | 2.4.5 |
| Styling | Tailwind CSS | 3.4.1 |
| Global State | Redux Toolkit + redux-persist | 2.2.5 |
| Server State | RTK Query (via baseApi) | 2.2.5 |
| Local State | Zustand | 4.5.4 |
| Forms | Formik + Yup | 2.4.6 / 1.4.0 |
| Tables | TanStack Table | 8.17.3 |
| Charts | ECharts | 6.0.0 |
| Notifications | react-toastify, sonner | — |
| Testing | Jest + React Testing Library | 30.2.0 / 16.3.0 |
| Linting | ESLint + Prettier | 8.57.0 / 3.2.5 |
| Pre-commit | Husky + lint-staged | — |

---

## Git

- **Base branch:** `dev` (feature/* and fix/* PRs target `dev`, not main/master)
- **Branch naming:** `feature/{ticket}-{slug}`, `fix/{ticket}-{slug}`, `hotfix/{ticket}-{slug}`
- **Hotfix flow:** Branch from `master` → PR directly to `master` → cherry-pick to `dev`

## Commands

```bash
npm run dev          # Start dev server
npm run build        # Production build
npm run start        # Start production server
npm run lint         # Run ESLint
npm run lint:fix     # Auto-fix ESLint issues
npm run format       # Prettier format all ts/tsx/md
npm run test         # Run Jest tests
npm run test:watch   # Jest watch mode
```

---

## Architecture Patterns

### App Router Structure

```
src/app/
├── (admin)/[teamOwnerId]/   # Workspace-scoped admin routes
├── (setup)/                 # Config/admin-only routes
├── auth/                    # Public auth routes
├── api/                     # Next.js API routes
├── _components/             # Shared components (layout/, common/, icons/)
├── layout.tsx               # Root layout
├── providers.tsx            # Redux, theme, toast providers
└── globals.css
```

- Route groups use parentheses: `(admin)`, `(setup)`
- Private component dirs use underscore prefix: `_components/`, `_modals/`
- Dynamic segments use brackets: `[teamOwnerId]`, `[leadId]`
- Every route can have `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`

### Feature Directory Pattern

Each feature route follows logic/view/config separation:

```
feature-name/
├── page.tsx                 # Route entry — composes logic + view
├── Feature.logic.tsx        # Business logic hook (data fetching, handlers)
├── Feature.view.tsx         # Pure presentation component
├── Feature.config.ts        # Constants, column defs, config
└── _components/             # Feature-private components
```

### Source Directory Layout

```
src/
├── app/       # Next.js pages, layouts, API routes
├── hook/      # Custom React hooks (31 files)
├── model/     # TypeScript interfaces (32+ files, .model.ts suffix)
├── store/     # Redux store + RTK Query (Store.redux.ts, Apis/)
├── utils/     # Utility functions (.util.ts / .utils.ts suffix)
└── constant/  # Enums and constants (.constant.ts suffix)
```

---

## State Management

### RTK Query — Server State

- **Single baseApi** in `store/Apis/base.api.ts` with all `tagTypes`
- All API slices use `baseApi.injectEndpoints()` — never `createApi()` again
- Auto-generated hooks: `useGetLeadsQuery`, `useCreateLeadMutation`, etc.
- Reset all cache with one dispatch: `dispatch(resetApiCache())` from `store/Apis/resetApiCache.util.ts`

```typescript
// Query
const { data, isLoading, error } = useGetLeadsQuery({ page: 1, limit: 10 });

// Mutation
const [createLead, { isLoading: isCreating }] = useCreateLeadMutation();
await createLead(payload).unwrap();

// Cache invalidation in mutation definition
invalidatesTags: ['Lead']
```

### Redux — Global State

- Typed `useAppSelector` / `useAppDispatch` from `@/store`
- Selectors live in `*.selector.ts` files alongside reducers
- `redux-persist` handles auth and workspace persistence

```typescript
const user = useAppSelector(AuthSelector.selectUser);
const dispatch = useAppDispatch();
dispatch(setHasFormChanged(true));
```

### Zustand — Local/Ephemeral State

Use for UI-local state that doesn't need Redux (e.g., URL history, transient UI state).

```typescript
const { history, setHistory } = useUrlHistoryStore();
```

---

## Component Patterns

- Always use function declarations for components and hooks (not arrow functions)
- Define props interface at top of file
- Use `React.FC<Props>` or typed function params — never untyped
- Use `React.memo`, `useCallback`, `useMemo` for performance-sensitive components
- Use `useMergeState` (custom hook) instead of multiple `useState` calls for related fields

```typescript
interface UserCardProps { user: User; onSelect?: (id: string) => void; }

function UserCard({ user, onSelect }: UserCardProps) {
  return <div onClick={() => onSelect?.(user.id)}>{user.firstName}</div>;
}
```

### Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Component files | PascalCase `.tsx` | `LeadDetailModal.tsx` |
| Hook files | camelCase `use*` prefix | `useWorkspaceRouter.ts` |
| Model files | PascalCase `.model.ts` | `Lead.model.ts` |
| API slice files | PascalCase `.api.ts` | `Lead.api.ts` |
| Util files | camelCase `.util.ts` | `format.util.ts` |
| Constant files | PascalCase `.constant.ts` | `Permission.constant.ts` |
| Test files | matching source `.test.tsx` | `LeadList.test.tsx` |

---

## Styling

- **Tailwind utilities only** — no custom CSS classes
- Use `cn()` from `@/utils/common.util` for conditional class merging (wraps `clsx` + `tailwind-merge`)
- NextUI components for complex interactive elements (inputs, modals, buttons)

```typescript
import { cn } from '@/utils/common.util';

<button className={cn('px-4 py-2 rounded', disabled && 'opacity-50 cursor-not-allowed')}>
```

---

## Form Patterns

- Formik + Yup for complex validated forms
- `useMergeState` for simple local form state without Formik
- Always show inline field errors; disable submit while `isLoading`

```typescript
// Simple form state
const [form, setForm] = useMergeState({ firstName: '', email: '' });

// Yup schema
const schema = Yup.object({ email: Yup.string().email().required() });
```

---

## TypeScript Standards

- Interfaces for object shapes (not `type` aliases)
- Enums for fixed value sets (not union string literals)
- Never use `any` — use `unknown` + type narrowing if needed
- Export models from `src/model/`, import via `@/model`

```typescript
interface Lead { id: string; firstName: string; status: LEAD_STATUS; }
enum LEAD_STATUS { NEW = 'NEW', PRIME = 'PRIME', CLOSE = 'CLOSE' }
```

---

## Test Patterns

- Tests live in `__tests__/` at project root, mirroring `src/` structure
- File suffix: `.test.ts` or `.test.tsx`
- Structure: `describe` > `describe('Rendering'|'Interactions'|'Edge Cases')` > `it`

```typescript
// Mock RTK Query hook
jest.mock('@/store/Apis/Lead.api', () => ({
  useGetLeadsQuery: jest.fn(() => ({ data: { data: [] }, isLoading: false })),
}));

// Mock permissions
jest.mock('@/hook/usePermission', () => ({
  usePermission: () => ({ checkPermissionV2: jest.fn(() => true) }),
}));

// Render with Redux provider
const renderWithProvider = (ui) => render(<Provider store={mockStore}>{ui}</Provider>);
```

---

## Code Review Checklist

- [ ] Loading states handled (skeleton/spinner while `isLoading`)
- [ ] Error states handled with user-facing feedback
- [ ] RTK Query tag invalidation set on mutations
- [ ] No `fetch`/`axios` — use RTK Query hooks only
- [ ] No `Context API` for global state — use Redux
- [ ] No custom CSS — Tailwind utilities only
- [ ] No `any` type — proper TypeScript types
- [ ] `useMergeState` used for related form fields (not multiple `useState`)
- [ ] ARIA labels on interactive elements; keyboard nav supported
- [ ] Responsive layout verified (mobile + desktop)
- [ ] Permissions checked via `usePermission().checkPermissionV2()`
- [ ] `useIsMounted` used for SSR-unsafe code

---

## Debug Patterns

| Issue | Likely Cause | Fix |
|---|---|---|
| Hydration mismatch | Server/client render differs | Wrap client-only code with `useIsMounted` check |
| Stale RTK data | Missing tag invalidation | Add `invalidatesTags` to mutation |
| Infinite re-renders | Missing `useCallback`/`useMemo` deps | Stabilize references |
| Redux state not persisted | Slice not in persist config | Add to `Store.persist.ts` whitelist |
| Permission check always false | Wrong enum or stale user state | Verify `PermissionEnum` value + Redux user slice |

---

## Anti-Patterns

```typescript
// Never: any type
const data: any = res;
// Always: typed response
const data: Lead = res;

// Never: direct state mutation
state.user.name = 'John';
// Always: immutable update
setState(prev => ({ ...prev, user: { ...prev.user, name: 'John' } }));

// Never: multiple useState for related fields
const [first, setFirst] = useState('');
const [last, setLast] = useState('');
// Always: useMergeState
const [form, setForm] = useMergeState({ first: '', last: '' });

// Never: raw fetch/axios
const res = await fetch('/api/leads');
// Always: RTK Query
const { data } = useGetLeadsQuery();

// Never: createApi in feature slice
const myApi = createApi({ ... });
// Always: inject into baseApi
baseApi.injectEndpoints({ endpoints: (builder) => ({ ... }) });

// Never: Context API for shared state
const UserContext = createContext();
// Always: Redux + selector
const user = useAppSelector(AuthSelector.selectUser);

// Never: custom CSS class
<div className="my-button">
// Always: Tailwind
<div className="px-4 py-2 bg-blue-600 text-white rounded">
```
