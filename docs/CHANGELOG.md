# Changelog

## 1.0.0

- Publish the first stable release for RimWorld 1.6.
- Add an integrated preview of the selected pawn or corpse beside Nice Inventory Tab.
- Add a toolbar toggle that shows or hides the preview and its reserved width.
- Rotate the portrait through all four orientations with left and right controls.
- Close the preview automatically with the host inventory tab.
- Validate Nice Inventory Tab's runtime compatibility surface before applying patches.
- Disable safely without modifying the original mod when the expected compatibility surface is unavailable.
- Add English and French player-facing tooltips.
- Add the polished primary Workshop image and the secondary in-game screenshot.
- Add clean package and Workshop staging workflows.
- Publish Steam Workshop item `3777164660`.
- Preserve the real Steam `About/PublishedFileId.txt` for future updates.

## 0.1.1-dev

- Validate Nice Inventory Tab's `Prefix` and empty `AddonCheckBoxes` compatibility hooks before activation.
- Reuse Nice Inventory Tab's validated `ref Vector2` size argument to reserve the integrated preview area.
- Add a portrait toolbar toggle without modifying the original mod's assembly.
- Integrate the equipped-pawn preview directly beside Nice Inventory Tab instead of opening a separate window.
- Expand the gear tab only while the preview is visible.
- Remove popup lifetime and position handling; the preview now closes with the inventory tab.
- Follow the currently selected pawn or corpse.
- Render the pawn through RimWorld's standard portrait cache.
- Replace textual controls and cardinal-direction labels with RimWorld's vanilla left and right arrow textures plus localized tooltips.
- Lower the integrated panel below the tab close control.
- Remove the redundant pawn-name header and the add-on's custom rotation textures.
- Align the preview directly on the base tab boundary so Nice Inventory Tab's existing internal margin defines the visible inter-column spacing.
- Map the left arrow to clockwise rotation and the right arrow to counterclockwise rotation.
- Add the validated integrated-preview screenshot for release preparation.

## 0.1.0-dev

- Establish the RimWorld 1.6 add-on structure.
- Declare Harmony and Nice Inventory Tab dependencies.
- Add the `net472` build project and build command.
- Add a clean RimWorld package generator with a runtime allowlist and ZIP layout validation.
- Add a Harmony compatibility bootstrap using runtime type discovery.
- Add project workflow, roadmap, testing and publication documentation.
