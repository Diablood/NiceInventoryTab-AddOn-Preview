# Milestone validation and publication

## Before the final commit

- Build successfully.
- Complete `docs/TESTING_CURRENT.md`.
- Move durable coverage into `docs/TESTING.md`.
- Update `README.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md` and `docs/CHANGELOG.md`.
- Keep `About/About.xml` and the C# project versions aligned.
- Run `tools/check-project-consistency.cmd -ExpectedVersion <version>`.
- Run `tools/check-project-consistency.cmd -ExpectedVersion <version> -RequirePublicationReady`.
- Run `package-mod.cmd` and inspect the clean installable ZIP described in [`PACKAGING.md`](PACKAGING.md).
- Check `git diff --cached --check`.

## Normal publication order

1. Commit the validated feature branch.
2. Fast-forward it into `develop`.
3. Push `develop`.
4. Create one annotated final tag.
5. Push the tag.

## Initial empty-repository publication

The first milestone is exceptional because no integration branch exists yet:

1. Create and commit the milestone on its dedicated feature branch.
2. Create `develop` at that validated commit.
3. Push `develop` before the optional feature branch.
4. Configure `develop` as the GitHub default branch during pre-`1.0.0` development.
5. Create and push the annotated milestone tag from the same commit.
6. Leave `main` reserved for the first stable release.

The first milestone does not require an artificial merge commit. The feature branch, `develop` and the final tag must all resolve to the same validated commit.

## Permanent rules

- Do not publish before explicit local validation.
- Do not tag local revisions such as `r1`.
- Do not merge with an incidental merge commit.
- Do not work directly on `main` or `develop` after repository initialization.
- Use complete ready-to-replace files in local revision archives.
- Development revision snapshots exclude `.git`, `bin`, `obj`, DLL, PDB, ZIP and patch files.
- Final player packages are generated only through `package-mod.cmd` and include the compiled DLL but no development content.
- A new milestone starts from the latest validated tag through `develop`.
