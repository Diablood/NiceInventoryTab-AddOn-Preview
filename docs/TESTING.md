# Durable testing

## Build

- Release build succeeds against RimWorld 1.6 managed assemblies.
- Output contains only the add-on assembly and no copied RimWorld or Harmony DLL.
- `About/About.xml`, project `Version`, `AssemblyVersion` and `FileVersion` remain synchronized.

## Final package

- `package-mod.cmd` performs a Release build unless `-SkipBuild` is supplied.
- The archive name uses the version declared in `About/About.xml`.
- The ZIP contains exactly one installable root folder named `NiceInventoryTab-AddOn-Preview`.
- Required runtime files are present: `About/About.xml`, `LoadFolders.xml` and the compiled DLL.
- English and French keyed translations are included when present.
- Rotation controls use RimWorld vanilla `TexUI.ArrowTexLeft` and `TexUI.ArrowTexRight`; no add-on rotation textures are packaged.
- Source, documentation, screenshots, tools, debug symbols, build intermediates and repository metadata are absent.
- The completed ZIP is reopened and validated before success is reported.

## Load order

- Harmony loads before the add-on.
- Nice Inventory Tab loads before the add-on.
- Missing Nice Inventory Tab never causes a startup exception; the dependency declaration normally prevents this state.

## Compatibility surface

- The runtime type `NiceInventoryTab.ITab_Pawn_Gear_Patch` is found.
- `Prefix` remains a static `bool` method receiving `ITab_Pawn_Gear` and `ref Vector2`.
- `AddonCheckBoxes` remains a static `void` method receiving `Rect` and `int`.
- The empty `AddonCheckBoxes` extension hook is patched for the preview toggle.
- Nice Inventory Tab's `Prefix` is patched before and after its drawing routine.
- The validated `ref Vector2` argument is restored before drawing and expanded after drawing only while the preview is visible.
- Repeated draw frames never accumulate additional width.
- A signature mismatch produces one explicit error and leaves the add-on inactive.
- No direct assembly reference to Nice Inventory Tab is required.

## Preview behavior

- Preview is drawn only while Nice Inventory Tab is drawing its gear tab.
- Closing the inventory tab removes the preview without a separate close operation.
- The toolbar toggle changes portrait visibility and tab width together.
- No movable preview window or stored window position exists.
- Preview follows the currently selected pawn.
- A selected corpse resolves to its inner pawn.
- No selection produces an instruction instead of an exception.
- Apparel changes are reflected after RimWorld invalidates the portrait cache.
- Two vanilla arrow controls rotate through north, east, south and west.
- The left arrow rotates clockwise and the right arrow rotates counterclockwise.
- No cardinal-direction label or duplicated pawn name is shown to the player.
- The preview panel starts below the tab close control.
- Repeated rotation does not change the selected pawn's actual map rotation.
- A portrait-rendering exception is logged once and does not break Nice Inventory Tab.

## UI regression

- Existing Nice Inventory Tab buttons retain their behavior.
- The add-on button uses the extension slot supplied by `AddonCheckBoxes`.
- The visible preview receives dedicated width rather than covering inventory contents.
- Hiding the preview restores the unmodified tab width.
- The Equipment-to-preview spacing matches the host tab's existing inter-column spacing.
- The preview border never overlaps the Equipment block or the close control.
- GUI font and anchor state are restored after custom drawing.
- Repeated show, hide, close, reopen, selection and rotation operations do not leave a stuck GUI state.

## Compatibility evaluation

- Test at least one humanlike colonist with vanilla apparel.
- Test a corpse.
- Test modded apparel or additional pawn render nodes when available.
- Record whether the standard portrait renderer displays the equipped weapon; weapon rendering is evaluated separately and is not assumed.

## Release documentation

- `README.md` references a representative current screenshot.
- `docs/images/workshop-preview.png` exists and reflects the validated layout.
- Documentation images remain outside the generated player-facing ZIP.
