# Branching workflow

## Branch roles

| Branch | Role |
|---|---|
| `main` | Stable public releases beginning with `1.0.0` |
| `develop` | Latest validated and integrated development milestone |
| `feature/*` | One temporary feature milestone |
| `fix/*` | One temporary corrective milestone |
| `hotfix/*` | Stable correction after `1.0.0` |

No ordinary work is committed directly to `main` or `develop` after the initial empty-repository bootstrap.

## Initial repository bootstrap

For the first milestone only:

1. Create the first commit on `feature/project-foundation`.
2. Create `develop` at the validated feature commit.
3. Push `develop` and make it the default GitHub branch.
4. Optionally publish the feature branch for traceability.
5. Create the annotated `v0.1.0-dev` tag at the same commit.
6. Keep `main` reserved until the first stable release.

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

## Integration

After explicit local validation and publication authorization:

```powershell
git switch develop
git pull --ff-only origin develop
git merge --ff-only feature/<milestone-name>
git push origin develop
```

## Tag

```powershell
git tag -a v<version> -m "<version> - <short description>"
git push origin v<version>
```

The tag and `develop` must point to the same commit. Published tags are never moved or rewritten.
