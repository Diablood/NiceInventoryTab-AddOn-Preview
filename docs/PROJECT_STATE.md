# Project state

## Latest validated milestone

- Version: `0.1.0-dev`
- Name: Establish project foundation
- Branch: `feature/project-foundation`
- Tag: `v0.1.0-dev`
- Status: validated and closed
- Latest local validation revision: `r3`

## Validated scope

- RimWorld 1.6 mod metadata and dependency declaration.
- `net472` C# project using the maintainer's RimWorld and Harmony paths.
- Harmony bootstrap without a compile-time dependency on Nice Inventory Tab's DLL.
- Runtime discovery of `NiceInventoryTab.ITab_Pawn_Gear_Patch`.
- Rotation state foundation for the later preview control.
- Branching, testing, publication and consistency documentation.
- Clean final-mod ZIP generator using a runtime allowlist and post-generation validation.
- Quote-safe Windows path handling in `package-mod.cmd`.

## Validation result

- Project consistency check passed.
- Release build passed.
- Clean player-facing ZIP generated successfully.
- Harmony compatibility bootstrap initialized exactly once.
- Nice Inventory Tab opened and behaved normally.
- No add-on regression or red error was observed during the local test pass.

## Packaging baseline

`package-mod.cmd` builds the Release DLL and creates `dist/NiceInventoryTab-AddOn-Preview-<version>.zip`. The ZIP contains one directly installable mod folder and excludes source, documentation, tooling, debug symbols and repository files.

## Deliberately deferred

- Drawing the pawn portrait.
- Adding the show/hide preview control.
- Adding clockwise and counterclockwise controls.
- Persisting user settings.
- Compatibility testing with alien races and custom render nodes.

## Next milestone

```text
0.1.1-dev - Add rotatable pawn preview prototype
branch: feature/rotatable-pawn-preview-prototype
base: v0.1.0-dev
```

The next milestone will validate the expected Nice Inventory Tab patch targets and add the first visible equipped-pawn preview with four orientations. Compatibility failures must disable the preview safely without altering the original mod.
