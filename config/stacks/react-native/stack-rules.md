# React Native Stack Rules

> **TODO:** Fill in when the React Native project is set up.
> Use the NestJS or Next.js stack-rules.md as a template.

## Stack

- **Framework**: React Native (version TBD)
- **Navigation**: TBD
- **State Management**: TBD
- **Testing**: Jest
- **Linting**: ESLint + Prettier

## Commands

```bash
# Build
npm run build          # or: npx react-native build

# Lint
npm run lint:fix

# Test
npm test

# Run
npm run ios            # iOS simulator
npm run android        # Android emulator
```

## Architecture Patterns

TODO: Define component structure, navigation patterns, screen organization.

## State Management

TODO: Define state management patterns (Redux, Zustand, etc.)

## Component Patterns

TODO: Define component patterns, naming conventions, styling approach.

## Code Review Checklist

- [ ] Performance: no unnecessary re-renders, FlatList for long lists
- [ ] Platform handling: Platform.OS checks where needed
- [ ] Accessibility: accessible props on interactive elements
- [ ] Offline: graceful handling of network failures
- [ ] Navigation: proper back handling, deep linking

## Test Patterns

TODO: Define test patterns for components, hooks, navigation.

## Debug Patterns

TODO: Define common React Native debugging patterns.
