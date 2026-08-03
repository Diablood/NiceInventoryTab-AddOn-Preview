# Branching workflow

## Branch roles

| Branch | Role |
|---|---|
| `main` | Stable public releases beginning with `1.0.0` |
| `develop` | Latest validated and integrated development milestone |
| `feature/*` | One temporary feature or release-preparation milestone |
| `fix/*` | One temporary corrective milestone |
| `hotfix/*` | Stable correction after `1.0.0` |

No ordinary work is committed directly to `main` or `develop`.

## Starting a normal milestone

```powershell
git switch develop
git pull --ff-only origin develop
git fetch origin --tags
git status --short
git switch -c feature/<milestone-name>
git branch --show-current
```

Verify that `develop` points to the latest validated tag before creating the new branch.

## Validation and final commit

Local revision suffixes such as `r1` are used only for test archives. They never appear in the final commit or tag.

```powershell
git status --short
git add -A
git diff --cached --check
git commit -m "<version> - <short description>"
```

## Development integration

After explicit local validation and publication authorization:

```powershell
git switch develop
git pull --ff-only origin develop
git merge --ff-only feature/<milestone-name>
git push origin develop
```

## Development tags

```powershell
git tag -a v<version> -m "<version> - <short description>"
git push origin v<version>
```

The tag and `develop` must point to the same commit. Published tags are never moved or rewritten.

## First stable release

The validated `1.0.0` release is first integrated into `develop`, then promoted to `main` without creating a merge commit:

```powershell
git switch develop
git pull --ff-only origin develop
git merge --ff-only feature/initial-workshop-release
git push origin develop

git switch main
git pull --ff-only origin main
git merge --ff-only develop
git push origin main

git tag -a v1.0.0 -m "1.0.0 - Publish initial Workshop release"
git push origin v1.0.0
```

`main`, `develop` and `v1.0.0` must resolve to the same commit at publication.

## Stable hotfixes

After `1.0.0`, a stable correction starts from `main` on `hotfix/*`. Integrate the validated correction into `main`, tag the patch release, then fast-forward or replay the same correction into `develop` so future development retains it.
