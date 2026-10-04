# Durable testing

## Build

- Release build succeeds against RimWorld 1.6 managed assemblies.
- Output contains only the add-on assembly and no copied RimWorld or Harmony DLL.
- `About/About.xml`, project `Version`, `AssemblyVersion` and `FileVersion` remain synchronized.
- Development versions use `x.y.z-dev`; stable versions use `x.y.z`.
- Assembly versions always use four numeric components.

## Final package

- `package-mod.cmd` performs a Release build unless `-SkipBuild` is supplied.
- The archive name uses the version declared in `About/About.xml`.
- The ZIP contains exactly one installable root folder named `NiceInventoryTab-AddOn-Preview`.
- Required runtime files are present: `About/About.xml`, `About/Preview.png`, `LoadFolders.xml` and the compiled DLL.
- `About/Preview.png` is `640 × 360` or `1280 × 720` and below 1 MB.
- `About/PublishedFileId.txt` is included when the real Steam-generated file exists.
- English and French keyed translations are included.
- Source, documentation, tools, debug symbols, build intermediates and repository metadata are absent.
- The completed ZIP is reopened and validated before success is reported.

## Workshop staging

- `stage-workshop.cmd` builds the clean package and installs it beneath the selected RimWorld `Mods` directory.
- The staged directory contains the same runtime files as the validated ZIP.
- Existing `About/PublishedFileId.txt` content is preserved.
- A repository/staged Workshop ID mismatch blocks staging.
- No source, docs, tools or debug files enter the staged upload folder.
- A first upload without a Workshop ID is allowed and produces an explicit reminder to import the generated file afterward.

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
- The Nice Inventory Tab prefix return value is treated as the authoritative view-mode signal: `true` means vanilla `ITab_Pawn_Gear.FillTab` will run and the add-on must not draw or reserve width.
- Switching to vanilla view never changes the player's own preview visibility choice, rotation or zoom state.
- Returning to Nice Inventory view restores preview behavior according to the player's existing preview visibility choice.
- Repeated draw frames and repeated Nice/vanilla switching never accumulate additional width.
- A signature mismatch produces one explicit error and leaves the add-on inactive.
- No direct assembly reference to Nice Inventory Tab is required.

## Preview behavior

- Preview is drawn only while Nice Inventory Tab is drawing its custom gear view.
- Preview is absent while the host mod allows RimWorld's vanilla gear view to draw.
- Closing the inventory tab removes the preview without a separate close operation.
- The toolbar toggle changes portrait visibility and tab width together in Nice Inventory view.
- Preview follows the currently selected pawn or corpse.
- Vanilla minus and plus controls are shown at the top of the preview.
- Zoom starts at 100%, is bounded between 25% and 200%, and changes in 10% steps.
- Minus zooms out and plus zooms in without changing the selected pawn.
- RimWorld's vanilla portrait camera offset lowers the pawn within the frame.
- Large animals such as Thrumbos can be reduced until their visible body fits without premature head clipping.
- Two vanilla arrow controls rotate through all four orientations.
- The left arrow rotates clockwise and the right arrow rotates counterclockwise.
- No cardinal-direction label or duplicated pawn name is shown.
- The preview panel starts below the tab close control.
- Repeated rotation does not change the selected pawn's actual map rotation.
- A portrait-rendering exception is logged once and does not break Nice Inventory Tab.

## UI regression

- Existing Nice Inventory Tab buttons retain their behavior.
- Nice Inventory Tab's own custom/vanilla-view toggle retains control over which gear interface is displayed.
- The add-on button uses the extension slot supplied by `AddonCheckBoxes`.
- The visible preview receives dedicated width rather than covering inventory contents.
- Hiding the preview restores the unmodified tab width.
- Switching to vanilla view also restores the unmodified tab width without changing the add-on's saved visibility state.
- The Equipment-to-preview spacing matches the host tab's existing inter-column spacing.
- The preview border never overlaps the Equipment block or the close control.
- GUI font and anchor state are restored after custom drawing.
- The zoom row remains above the portrait and the rotation row remains below it.

## Release documentation

- `README.md` references a representative current screenshot.
- `docs/images/workshop-preview.png` exists and reflects the validated layout.
- `About/Preview.png` exists as the Workshop thumbnail.
- `docs/WORKSHOP_DESCRIPTION.md` contains the bilingual copy-paste description.
- `docs/WORKSHOP_PUBLICATION.md` documents update staging and stable publication.
- Documentation images remain outside the generated player-facing ZIP.
