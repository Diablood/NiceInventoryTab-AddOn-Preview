# Project state

## Latest validated milestone

- Version: `1.1.0`
- Name: Add zoom controls
- Branch: `feature/zoom-controls`
- Base: `main` at `19f3572`
- Tag: `v1.1.0`
- Status: validated and closed
- Latest local validation revision: `r3`
- Workshop ID: `3777164660`
- Workshop URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3777164660

## Validated release scope

- Add zoom-in and zoom-out controls using RimWorld's vanilla plus and minus icons.
- Keep the default portrait scale unchanged while allowing a 25% to 200% zoom range.
- Place zoom controls at the top of the preview and retain rotation controls at the bottom.
- Lower the rendered pawn with RimWorld's vanilla portrait camera offset.
- Preserve selection, corpse preview, rotation, visibility and tab-width behavior.
- Remove the unsupported root Workshop URL from `About/About.xml` while preserving `About/PublishedFileId.txt`.
- Update the English/French tooltips, Workshop description and player-facing documentation.

## Validation result

- Project consistency and publication-readiness checks passed for version `1.1.0`.
- The validated primary image is `1280 × 720` and remains below 1 MB.
- Release metadata and assembly versions match `1.1.0` / `1.1.0.0`.
- The zoom range, button mapping and portrait camera offset are covered by the repository consistency checks.
- In-game testing with a Thrumbo confirmed zooming, full-body framing and the lowered visual center.
- Startup testing confirmed the invalid metadata error is removed and the compatibility bootstrap initializes.
- The primary Workshop image retains its original composition and now shows the minus and plus zoom controls.
- The secondary Workshop image is the final in-game screenshot supplied after zoom validation.
- The clean update package preserves Workshop item ID `3777164660`.

## Workshop assets

```text
docs/images/workshop-main.png
```

Primary promotional image and `About/Preview.png` source.

```text
docs/images/workshop-preview.png
```

Secondary in-game screenshot showing the actual integrated preview.

## Deferred beyond 1.1.0

- Weapon rendering when RimWorld's standard portrait omits the equipped weapon.
- Mouse drag or mouse-wheel rotation.
- Persistent preview visibility, orientation or zoom settings.
- Dedicated compatibility adaptations for alternative portrait renderers.

## Maintenance baseline

Future Workshop updates must preserve `About/PublishedFileId.txt` unchanged so they continue to target item `3777164660`.
