---
name: ck:backend-development
description: Build backends with Node.js, Python, Go (NestJS, FastAPI, Django). Use for REST/GraphQL/gRPC APIs, auth (OAuth, JWT), databases, microservices, security (OWASP), Docker/K8s.
license: MIT
version: 1.0.0
argument-hint: "[framework] [task]"
---

# Backend Development Skill

## When to Use

- REST/GraphQL/gRPC API design
- Auth/authorization (OAuth, JWT, RBAC)
- Database schema, queries, migrations
- Caching, performance, microservices
- Security (OWASP), Docker/K8s deployment
- Testing, CI/CD, monitoring

## Technology Selection

| Need | Choose |
|------|--------|
| Fast development | Node.js + NestJS |
| Data/ML integration | Python + FastAPI |
| High concurrency | Go + Gin |
| ACID transactions | PostgreSQL |
| Caching | Redis |
| Internal services | gRPC |
| Public APIs | REST/GraphQL |

## Key Best Practices

**Security:** Argon2id passwords, parameterized queries, OAuth 2.1 + PKCE, rate limiting, security headers

**Performance:** Redis caching, DB indexing, connection pooling, CDN

**Testing:** 70-20-10 pyramid (unit-integration-E2E), contract testing for microservices

**DevOps:** Blue-green/canary deployments, feature flags, Prometheus/Grafana, OpenTelemetry

## Reference Navigation

- `backend-technologies.md` — Languages, frameworks, ORMs, message queues
- `backend-api-design.md` — REST, GraphQL, gRPC patterns
- `backend-security.md` — OWASP Top 10, input validation
- `backend-authentication.md` — OAuth 2.1, JWT, MFA
- `backend-performance.md` — Caching, query optimization, scaling
- `backend-architecture.md` — Microservices, event-driven, CQRS
- `backend-testing.md` — Testing strategies, CI/CD
- `backend-devops.md` — Docker, Kubernetes, monitoring
