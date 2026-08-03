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

## Normal development publication

1. Commit the validated feature branch.
2. Fast-forward it into `develop`.
3. Push `develop`.
4. Create one annotated final tag.
5. Push the tag.

## Initial stable Workshop publication

The first Workshop release has an additional dependency: Steam creates the real `About/PublishedFileId.txt` only after the first successful upload.

1. Prepare and validate `1.0.0` on `feature/initial-workshop-release`.
2. Generate and stage the clean local mod with `stage-workshop.cmd`.
3. Upload the item privately or unlisted through RimWorld.
4. Copy the generated `PublishedFileId.txt` back into the repository.
5. Record the Workshop URL and identifier.
6. Rerun all release checks and create the final release commit.
7. Fast-forward the release commit into `develop`.
8. Fast-forward `main` from `develop`.
9. Create and push the unique annotated tag `v1.0.0`.
10. Make the Workshop item public after the page and dependencies are verified.

The complete procedure is defined in [`WORKSHOP_PUBLICATION.md`](WORKSHOP_PUBLICATION.md).

## Permanent rules

- Do not publish before explicit local validation.
- Do not tag local revisions such as `r1`.
- Do not merge with an incidental merge commit.
- Do not work directly on `main` or `develop`.
- Use complete ready-to-replace files in local revision archives.
- Development revision snapshots exclude `.git`, `bin`, `obj`, DLL, PDB, ZIP and patch files.
- Final player packages are generated only through `package-mod.cmd`.
- `About/Preview.png` is required for Workshop-ready packages.
- Never create a fake `PublishedFileId.txt`.
- Once Steam creates the identifier, preserve it in the repository, generated package and local staging folder.
