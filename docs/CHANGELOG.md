# Changelog

## 1.3.0

- Add a preview-only clothing/armor button beside the helmet button, using the Core shirt icon and English/French action tooltips.
- Link clothing and headgear visibility: hiding clothing hides both; showing headgear restores the whole outfit; showing clothing restores the remembered headgear preference. Both start enabled and retain their choices for the session.
- Pass renderClothes to the standard portrait renderer without modifying actual worn apparel or Nice Inventory Tab.

## 1.2.0

- Add a preview-only helmets/hats toggle beside the zoom controls, with a Core helmet icon and English/French action tooltips.
- Show headgear by default and preserve the choice throughout the session, independently of visibility, zoom and rotation.
- Use the portrait renderer's renderHeadgear parameter without changing worn items or the host mod.
- Apparel visibility control remains reserved for 1.3.0.

## 1.1.1

- Hide the integrated preview whenever Nice Inventory Tab switches to RimWorld's vanilla gear view.
- Release the preview's reserved width while the vanilla view is active.
- Preserve the user's preview visibility choice, rotation and zoom when switching back to Nice Inventory Tab.
- Use the already validated Nice Inventory Tab Harmony-prefix return value instead of depending on a private host-mod field.

## 1.1.0

- Add vanilla zoom-in and zoom-out controls at the top of the preview panel.
- Allow very large modded animals and pawns to be scaled down until their full body fits the preview.
- Apply RimWorld's vanilla portrait camera offset so pawns sit lower in the frame and tall heads remain visible longer while zooming.
- Remove the unsupported top-level Workshop URL metadata that caused an XML startup error in RimWorld 1.6.
- Refresh the primary Workshop image with the new vanilla zoom controls.
- Replace the secondary Workshop screenshot with the final validated in-game zoom layout.

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
- Add initial rotation state support.
- Add project workflow, roadmap, testing and publication documentation.
