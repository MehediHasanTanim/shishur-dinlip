# Git repository standards

## Branch naming

| Pattern | Use |
|---------|-----|
| `main` | Stable integration branch |
| `develop` | Optional integration branch (if used) |
| `feature/<short-name>` | New functionality |
| `fix/<short-name>` | Bug fixes |
| `chore/<short-name>` | Tooling, deps, docs |
| `release/<version>` | Release cut |

Examples: `feature/child-profiles`, `fix/timeline-scroll`, `chore/sprint-1-foundation`

## Commit messages

Prefer concise, imperative subject lines (≤ ~72 chars):

```text
Add Android/iOS flavor configuration for Sprint 1.1
```

Guidelines:

- Focus on **why**, not a file list.
- One logical change per commit when practical.
- Do not commit secrets, keystores, or `.env` files.

## What must never be committed

- Signing keystores / `key.properties`
- `.env` with secrets
- `google-services.json` / `GoogleService-Info.plist` (if added later with keys)
- Local IDE caches, `build/`, `.dart_tool/`

See root `.gitignore`.

## Pull requests

- Link the sprint / task when applicable.
- Note flavor or platform-specific testing performed.
- Keep PRs reviewable; prefer smaller vertical slices after foundation.

## Tags

Release tags: `v0.1.0`, `v1.0.0`, matching `pubspec.yaml` versionName.
