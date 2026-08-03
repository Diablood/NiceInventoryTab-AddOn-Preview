# Durable testing

## Build

- Release build succeeds against RimWorld 1.6 managed assemblies.
- Output contains only the add-on assembly and no copied RimWorld or Harmony DLL.

## Final package

- `package-mod.cmd` performs a Release build unless `-SkipBuild` is supplied.
- The archive name uses the version declared in `About/About.xml`.
- The ZIP contains exactly one installable root folder named `NiceInventoryTab-AddOn-Preview`.
- Required runtime files are present: `About/About.xml`, `LoadFolders.xml` and the compiled DLL.
- Optional runtime content is included only from the approved directories.
- Source, documentation, tools, debug symbols, build intermediates and repository metadata are absent.
- The completed ZIP is reopened and validated before success is reported.

## Load order

- Harmony loads before the add-on.
- Nice Inventory Tab loads before the add-on.
- Missing Nice Inventory Tab never causes a startup exception; the dependency declaration normally prevents this state.

## Compatibility bootstrap

- The runtime type `NiceInventoryTab.ITab_Pawn_Gear_Patch` is found.
- Failure to find the type produces one explicit error and leaves the add-on inactive.
- No direct assembly reference to Nice Inventory Tab is required.

## Future preview regression coverage

- Preview follows the pawn currently displayed by the gear tab.
- Apparel changes are reflected after RimWorld invalidates the portrait cache.
- All four rotations render correctly.
- Closing and reopening the tab does not leak render textures or GUI state.
- Non-humanlike pawns and unsupported renderers fail gracefully.
