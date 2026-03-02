---
name: ck:web-testing
description: Web testing with Playwright, Vitest, k6. E2E/unit/integration/load/security/visual/a11y testing. Use for test automation, flakiness, Core Web Vitals, mobile gestures, cross-browser.
license: Apache-2.0
version: 3.0.0
argument-hint: "[test-type] [target]"
---

# Web Testing Skill

## Quick Start

```bash
npx vitest run                         # Unit tests
npx playwright test                    # E2E tests
npx playwright test --ui               # E2E with UI mode
k6 run load-test.js                    # Load tests
npx @axe-core/cli https://example.com  # Accessibility
```

## Testing Strategy

| Model | Structure | Best For |
|-------|-----------|----------|
| Pyramid | Unit 70% > Integration 20% > E2E 10% | Monoliths |
| Trophy | Integration-heavy | Modern SPAs |
| Honeycomb | Contract-centric | Microservices |

## CI/CD Pipeline

```yaml
steps:
  - run: npm run test:unit    # Gate 1: fast fail
  - run: npm run test:e2e     # Gate 2: after unit pass
  - run: npm run test:a11y    # Accessibility check
  - run: npx lhci autorun     # Core Web Vitals
```

## Reference Navigation

- `references/unit-integration-testing.md` — Vitest, AAA pattern, browser mode
- `references/e2e-testing-playwright.md` — Fixtures, sharding, selectors
- `references/playwright-component-testing.md` — Component testing patterns
- `references/test-data-management.md` — Factories, fixtures, seeding
- `references/database-testing.md` — Testcontainers, transactions
- `references/ci-cd-testing-workflows.md` — GitHub Actions, sharding
- `references/performance-core-web-vitals.md` — LCP/CLS/INP, Lighthouse CI
- `references/visual-regression.md` — Screenshot comparison
- `references/accessibility-testing.md` — WCAG, axe-core
- `references/security-testing-overview.md` — OWASP Top 10
- `references/load-testing-k6.md` — k6 patterns
- `references/test-flakiness-mitigation.md` — Stability strategies
- `references/pre-release-checklist.md` — Release checklist
