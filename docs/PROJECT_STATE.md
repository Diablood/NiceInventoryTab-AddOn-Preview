# Project state

## Current milestone

- Version: `0.1.0-dev`
- Name: Establish project foundation
- Branch: `feature/project-foundation`
- Status: ready for local build and validation

## Included

- RimWorld 1.6 mod metadata and dependency declaration.
- `net472` C# project using the maintainer's usual RimWorld and Harmony paths.
- Harmony bootstrap without a compile-time dependency on Nice Inventory Tab's DLL.
- Runtime discovery of `NiceInventoryTab.ITab_Pawn_Gear_Patch`.
- Rotation state foundation for the later preview control.
- Branching, testing, publication and consistency documentation.

## Deliberately deferred

- Drawing the pawn portrait.
- Adding the show/hide preview control.
- Adding clockwise and counterclockwise controls.
- Persisting user settings.
- Compatibility testing with alien races and custom render nodes.

## Next milestone

`0.1.1-dev - Add compatibility diagnostics`

The next milestone should validate the exact Nice Inventory Tab method signatures at runtime and expose clear diagnostics before any visible UI patch is introduced.
