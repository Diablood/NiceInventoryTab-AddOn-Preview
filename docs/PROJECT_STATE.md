# Project state

## Latest validated milestone

- Version: `0.1.1-dev`
- Name: Add rotatable pawn preview prototype
- Branch: `feature/rotatable-pawn-preview-prototype`
- Base: `v0.1.0-dev`
- Tag: `v0.1.1-dev`
- Status: validated and closed
- Latest local validation revision: `r8`

## Validated scope

- Validate Nice Inventory Tab's runtime `Prefix` and `AddonCheckBoxes` signatures before activation.
- Add the preview toggle through the original mod's empty add-on hook.
- Integrate the preview directly beside Nice Inventory Tab instead of using an independent window.
- Expand and restore the tab width through the validated `ref Vector2` argument without cumulative growth.
- Close the preview automatically with the inventory tab.
- Follow the selected pawn or corpse and render it through RimWorld's standard portrait cache.
- Rotate through all four orientations without changing the pawn's map rotation.
- Use vanilla left and right arrow textures with localized tooltips and no cardinal labels.
- Keep the preview below the close control and omit the duplicated pawn name.
- Match the Equipment-to-preview spacing to Nice Inventory Tab's existing internal column spacing.
- Preserve a clean player-facing ZIP containing no source, documentation or screenshots.

## Validation result

- Project consistency check passed.
- Release build passed.
- Clean player-facing ZIP generation passed.
- Compatibility bootstrap and integrated-preview patches initialized successfully.
- The preview opened, closed, followed selection and rotated correctly.
- Hiding the preview restored the original tab width.
- Closing Nice Inventory Tab removed the preview immediately.
- The tab width remained stable over repeated draw frames.
- The final `r8` horizontal alignment matched the Clothing-to-Equipment spacing.
- No overlap with the Equipment block or close control remained.
- No add-on regression or red error was observed during the final local test pass.

## Workshop asset

The validated representative screenshot is stored at:

```text
docs/images/workshop-preview.png
```

It is referenced from `README.md` and excluded from the generated player package.

## Deferred beyond the validated prototype

- Weapon rendering when RimWorld's standard portrait omits the equipped weapon.
- Mouse drag, mouse-wheel rotation or zoom.
- Dedicated compatibility work for alternative portrait renderers.
- Persistent visibility or orientation settings beyond the current session.

## Next milestone

```text
0.1.2-dev - Prepare initial Workshop release
branch: feature/workshop-release-preparation
base: v0.1.1-dev
```

The next milestone should finalize player-facing release metadata, confirm a clean install from the generated ZIP and decide whether the first public Workshop build is published as another development tag or promoted to `1.0.0`.
