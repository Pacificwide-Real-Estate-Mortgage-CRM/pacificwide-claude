# Branch Management

## Naming Convention

**Format:** `<type>/{notion-id}-{slug}` — use Notion Unique ID (e.g., `RRR-351`)

| Type | Purpose | Example |
|------|---------|---------|
| `feature/` | New features | `feature/RRR-351-oauth-login` |
| `fix/` | Bug fixes | `fix/RRR-456-db-timeout` |
| `refactor/` | Code restructure | `refactor/api-cleanup` |
| `docs/` | Documentation | `docs/api-reference` |
| `test/` | Test improvements | `test/integration-suite` |
| `chore/` | Maintenance | `chore/deps-update` |
| `hotfix/` | Production fixes | `hotfix/RRR-789-payment-crash` |

> If no Notion ticket: use descriptive slug only (`feature/oauth-login`)

## Branch Lifecycle

### Create
```bash
git checkout dev
git pull origin dev
git checkout -b feature/123-new-feature
```

### During Development
```bash
# Regular commits
git add <files> && git commit -m "feat(scope): description"

# Stay current with dev
git fetch origin
git rebase origin/dev
```

### Before Merge
```bash
# Push final state
git push origin feature/123-new-feature

# Or after rebase (feature branches only)
git push -f origin feature/123-new-feature
```

### After Merge
```bash
# Delete local
git branch -d feature/123-new-feature

# Delete remote
git push origin --delete feature/123-new-feature
```

## Branch Strategies

### Simple (small teams)
```
main (production)
  └─ feature/* (development)
```

### Git Flow (releases)
```
main (production)
develop (staging)
  ├─ feature/*
  ├─ bugfix/*
  ├─ hotfix/*
  └─ release/*
```

### Trunk-Based (CI/CD)
```
main (always deployable)
  └─ short-lived feature branches
```

## Quick Commands

| Task | Command |
|------|---------|
| List branches | `git branch -a` |
| Current branch | `git rev-parse --abbrev-ref HEAD` |
| Switch branch | `git checkout <branch>` |
| Create + switch | `git checkout -b <branch>` |
| Delete local | `git branch -d <branch>` |
| Delete remote | `git push origin --delete <branch>` |
| Rename | `git branch -m <old> <new>` |
