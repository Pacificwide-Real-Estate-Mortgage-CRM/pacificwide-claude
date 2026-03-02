---
name: ck:ui-styling
description: Style UIs with shadcn/ui components (Radix UI + Tailwind CSS). Use for accessible components, themes, dark mode, responsive layouts, design systems, color customization.
license: MIT
version: 1.0.0
argument-hint: "[component or layout]"
---

# UI Styling Skill

## When to Use

- Building accessible UI components (dialogs, forms, tables, nav)
- Responsive, mobile-first layouts with Tailwind
- Dark mode, theme customization, design tokens
- shadcn/ui component installation and composition

## Quick Start

```bash
npx shadcn@latest init
npx shadcn@latest add button card dialog form
```

## Core Stack

- **shadcn/ui**: Radix UI primitives, copy-paste model, TypeScript-first
- **Tailwind CSS**: Utility-first, mobile-first, zero runtime, auto-purge

## Best Practices

1. Compose complex UIs from simple primitives
2. Use Tailwind utilities directly; extract only for true repetition
3. Mobile-first: start with base styles, layer responsive variants (`sm:`, `md:`, `lg:`)
4. Leverage Radix accessibility — add `aria-label` where needed
5. Use CSS variables / `@theme` for design tokens
6. Apply `dark:` variants consistently for dark mode
7. Avoid dynamic class names (breaks Tailwind purging)

## MUI v7 Grid (if using MUI instead of shadcn)

```typescript
<Grid size={{ xs: 12, md: 6 }}>  // v7 syntax only
```

## Reference Navigation

- `references/shadcn-components.md` — Full component catalog with usage patterns
- `references/shadcn-theming.md` — CSS variables, dark mode, color customization
- `references/shadcn-accessibility.md` — ARIA, keyboard nav, focus management
- `references/tailwind-utilities.md` — Layout, spacing, typography utilities
- `references/tailwind-responsive.md` — Breakpoints, container queries
- `references/tailwind-customization.md` — `@theme`, custom tokens, plugins

## Resources

- shadcn/ui: https://ui.shadcn.com/llms.txt
- Tailwind CSS: https://tailwindcss.com/docs
- Radix UI: https://radix-ui.com
