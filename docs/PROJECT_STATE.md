# Project state

## Latest validated milestone

- Version: `1.0.0`
- Name: Initial Workshop release
- Branch: `feature/initial-workshop-release`
- Base: `v0.1.1-dev`
- Tag: `v1.0.0`
- Status: validated and closed
- Latest local validation revision: `r3`
- Workshop ID: `3777164660`
- Workshop URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3777164660

## Validated release scope

- Promote the accepted integrated preview to the first stable release for RimWorld 1.6.
- Keep the runtime feature code unchanged from the validated `0.1.1-dev-r8` layout.
- Add the polished primary Workshop image and the secondary in-game screenshot.
- Add stable English/French Workshop metadata and publication documentation.
- Build clean installable packages without source, documentation or debug files.
- Stage a clean local Workshop copy while preserving the real Steam item identifier.
- Record `About/PublishedFileId.txt` with the permanent item ID `3777164660`.
- Link the stable metadata and documentation to the existing Workshop item.

## Validation result

- Project consistency checks passed for version `1.0.0`.
- The validated primary image is `1280 × 720` and remains below 1 MB.
- Release metadata and assembly versions match `1.0.0` / `1.0.0.0`.
- The functional preview behavior remains the accepted `0.1.1-dev-r8` implementation.
- The first Steam Workshop upload completed and created item `3777164660`.
- Steam's generated `About/PublishedFileId.txt` was imported into the repository.
- The Workshop URL and identifier agree.

## Workshop assets

```text
docs/images/workshop-main.png
```

Primary promotional image and `About/Preview.png` source.

```text
docs/images/workshop-preview.png
```

Secondary in-game screenshot showing the actual integrated preview.

## Deferred beyond 1.0.0

- Weapon rendering when RimWorld's standard portrait omits the equipped weapon.
- Mouse drag, mouse-wheel rotation or zoom.
- Persistent preview visibility or orientation settings.
- Dedicated compatibility adaptations for alternative portrait renderers.

## Maintenance baseline

Future Workshop updates must preserve `About/PublishedFileId.txt` unchanged so they continue to target item `3777164660`.
