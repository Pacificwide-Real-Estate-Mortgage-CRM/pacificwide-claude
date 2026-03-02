---
name: ck:react-best-practices
description: React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, reviewing, or refactoring React/Next.js code to ensure optimal performance patterns. Triggers on tasks involving React components, Next.js pages, data fetching, bundle optimization, or performance improvements.
argument-hint: "[component or pattern]"
---

# React Best Practices

Performance optimization guide for React/Next.js. Apply when writing components, reviewing code, or optimizing bundles.

## Priority Rules

### CRITICAL — Eliminating Waterfalls
- Use `Promise.all()` for independent async operations
- Start promises early, await late in API routes
- Use Suspense boundaries to stream content incrementally

### CRITICAL — Bundle Size
- Import directly, avoid barrel files (`index.ts` re-exports)
- Use `next/dynamic` / `React.lazy` for heavy components
- Load analytics/logging after hydration
- Preload on hover/focus for perceived speed

### HIGH — Server-Side Performance
- `React.cache()` for per-request deduplication
- Minimize data serialized to client components
- Parallelize server fetches by restructuring components
- Use `after()` for non-blocking post-response work

### MEDIUM — Re-render Optimization
- Don't subscribe to state only used in callbacks
- Use primitive dependencies in `useEffect`
- Functional `setState` for stable callbacks
- `startTransition` for non-urgent updates
- `useMemo` for expensive derived values, `useCallback` for child handlers

### MEDIUM — Rendering Performance
- Hoist static JSX outside components
- Use ternary, not `&&`, for conditional rendering
- `content-visibility: auto` for long off-screen lists

### LOW — JS Performance
- Build `Map`/`Set` for repeated lookups (O(1) vs O(n))
- Cache `localStorage`/`sessionStorage` reads
- Combine multiple `filter`/`map` into one loop
- Hoist `RegExp` creation outside loops

## Full Rules

Individual rule files: `rules/async-parallel.md`, `rules/bundle-barrel-imports.md`, etc.
Complete compiled guide: `AGENTS.md`
