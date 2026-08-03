# Milestone validation and publication

## Before the final commit

- Build successfully.
- Complete `docs/TESTING_CURRENT.md`.
- Move durable coverage into `docs/TESTING.md`.
- Update `docs/PROJECT_STATE.md`, `docs/ROADMAP.md` and `docs/CHANGELOG.md`.
- Keep `About/About.xml` and the C# project versions aligned.
- Run `tools/check-project-consistency.cmd -ExpectedVersion <version>`.
- Check `git diff --cached --check`.

## Publication order

1. Commit the validated feature branch.
2. Fast-forward it into `develop`.
3. Push `develop`.
4. Create one annotated final tag.
5. Push the tag.

## Permanent rules

- Do not publish before explicit local validation.
- Do not tag local revisions such as `r1`.
- Do not merge with an incidental merge commit.
- Do not work directly on `main` or `develop`.
- Use complete ready-to-replace files in local revision archives.
- Exclude `.git`, `bin`, `obj`, DLL, PDB, ZIP and patch files from snapshots.
