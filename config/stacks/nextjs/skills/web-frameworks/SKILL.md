---
name: ck:web-frameworks
description: Build with Next.js (App Router, RSC, SSR, ISR), Turborepo monorepos. Use for React apps, server rendering, build optimization, caching strategies, shared dependencies.
license: MIT
version: 1.0.0
argument-hint: "[framework] [feature]"
---

# Web Frameworks Skill

## When to Use

- Full-stack Next.js apps (SSR, SSG, RSC, ISR)
- Monorepos with shared packages (Turborepo)
- Build optimization, caching strategies, CI/CD

## Quick Start

```bash
# Single app
npx create-next-app@latest my-app && npm install remixicon

# Monorepo
npx create-turbo@latest my-monorepo
```

## Next.js Best Practices

- Default to Server Components; use Client Components only when needed
- Use `Image` component for automatic optimization
- Set proper metadata for SEO
- Caching: `force-cache`, `{ next: { revalidate: 3600 } }`, `no-store`
- Use `loading.tsx` and `error.tsx` for loading/error states

## Turborepo Best Practices

- Structure: `apps/` (Next.js apps) + `packages/` (shared UI, configs, types)
- Define task dependencies correctly (`^build` for topological order)
- Configure `outputs` for proper cache hits
- Enable remote caching for team collaboration

## turbo.json

```json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": { "dependsOn": ["^build"], "outputs": [".next/**", "dist/**"] },
    "dev": { "cache": false, "persistent": true },
    "lint": {},
    "test": { "dependsOn": ["build"] }
  }
}
```

## Reference Navigation

- `references/nextjs-app-router.md` — Routing, layouts, parallel routes
- `references/nextjs-server-components.md` — RSC patterns, streaming
- `references/nextjs-data-fetching.md` — fetch API, caching, revalidation
- `references/nextjs-optimization.md` — Images, fonts, bundle analysis
- `references/turborepo-setup.md` — Installation, workspace config
- `references/turborepo-caching.md` — Local/remote cache strategies

## Resources

- Next.js: https://nextjs.org/docs/llms.txt
- Turborepo: https://turbo.build/repo/docs
