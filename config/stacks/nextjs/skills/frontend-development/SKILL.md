---
name: ck:frontend-development
description: Build React/TypeScript frontends with modern patterns. Use for components, Suspense, lazy loading, useSuspenseQuery, MUI v7 styling, TanStack Router, performance optimization.
argument-hint: "[component or feature]"
---

# Frontend Development Guidelines

## When to Use

- Creating components/pages, fetching data (TanStack Query)
- Routing (TanStack Router), styling (MUI v7)
- Performance optimization, TypeScript best practices

## Core Principles

1. **Lazy load** heavy components: routes, DataGrid, charts, editors
2. **Suspense for loading**: use `<SuspenseLoader>`, never early returns with spinners
3. **useSuspenseQuery**: primary data fetching pattern
4. **Feature structure**: `api/`, `components/`, `hooks/`, `helpers/`, `types/` subdirs
5. **Styles**: inline if <100 lines, separate `.styles.ts` if >100 lines
6. **Import aliases**: `@/` (src), `~types`, `~components`, `~features`
7. **Notifications**: `useMuiSnackbar` only, never `react-toastify`

## File Structure

```
src/features/my-feature/
  api/myFeatureApi.ts
  components/MyFeature.tsx
  hooks/useMyFeature.ts
  helpers/myFeatureHelpers.ts
  types/index.ts
  index.ts
```

## Component Template

```typescript
import React, { useCallback } from 'react';
import { Box } from '@mui/material';
import { useSuspenseQuery } from '@tanstack/react-query';
import { featureApi } from '../api/featureApi';

interface MyComponentProps { id: number }

export const MyComponent: React.FC<MyComponentProps> = ({ id }) => {
    const { data } = useSuspenseQuery({
        queryKey: ['feature', id],
        queryFn: () => featureApi.getFeature(id),
    });

    return <Box sx={{ p: 2 }}>{/* content */}</Box>;
};

export default MyComponent;
```

## MUI v7 Grid

```typescript
<Grid size={{ xs: 12, md: 6 }}>  // v7 syntax
```

## Route Setup

```typescript
export const Route = createFileRoute('/my-route/')({
    component: lazy(() => import('@/features/my-feature/components/MyPage')),
    loader: () => ({ crumb: 'My Route' }),
});
```

## Resources

- `resources/component-patterns.md`, `resources/data-fetching.md`, `resources/common-patterns.md`
