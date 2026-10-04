# Current testing

## 1.3.0

Status: validated locally after `r3`; milestone closed for publication.

Maintainer confirmed r3 tests OK on 2026-10-04. In-game acceptance is user-reported; the agent did not independently rerun the game or inspect Player.log. Historical r1/r2 evidence below records superseded behavior. No Steam upload is claimed. Final publication-ready check, Release rebuild and package build passed with zero warnings/errors. The final ZIP contains eight runtime files (930763 bytes) and Workshop ID 3777164660.

- r3 consistency and Release build passed without warnings/errors. Compiled-state tests passed repeated outfit off/on with both headgear preferences and helmet restore-all from either preference.
- r3 package installed locally; eight files match the archive by SHA-256. Workshop ID preserved. Prior copy backed up as local-backup-1.3.0-r2-20261004-234354.zip.

### r3 change

Remember the headgear preference while clothing is hidden. Test clothing off/on with headgear initially visible and initially hidden; restore the original choice in both cases. Clicking helmet while the entire outfit is hidden explicitly enables both, regardless of the remembered preference. Earlier evidence below describes previous revisions.

### r2 evidence

- Consistency check and Release build passed with zero warnings/errors.
- Executed the compiled PreviewState transitions: defaults, hide outfit, restore via helmet, hide helmet, hide/show clothes without helmet, restore helmet. All expected states passed.
- Package 1.3.0-r2 generated and staged; all eight installed files match the archive by SHA-256. Workshop ID 3777164660 preserved.
- Previous installed copy backed up as local-backup-1.3.0-r1-20261004-233343.zip.


The maintainer accepted r1 overall but reported that hiding clothing also hid headgear and the helmet button then had no visible effect. Inspection confirmed PawnRenderNodeWorker_Apparel_Head requires both Clothes and Headgear flags. The maintainer selected linked controls on 2026-10-04: showing headgear after hiding clothing restores the entire outfit. The r1 evidence below predates this correction.

### Automated evidence (2026-10-04)

- Installed RimWorld 1.6 API confirms separate renderClothes and renderHeadgear arguments; PortraitParams forwards both separately to PawnCacheRenderer.
- Consistency check, Release build and package build passed with zero warnings/errors.
- Archive: dist/NiceInventoryTab-AddOn-Preview-1.3.0-r1.zip (930696 bytes, eight runtime files).
- Installed into D:\SteamLibrary\steamapps\common\RimWorld\Mods\NiceInventoryTab-AddOn-Preview; all eight files match the archive by SHA-256.
- Previous installed copy backed up in dist/local-backup-1.2.0-20261004-231341.zip.
- Workshop ID 3777164660 preserved. No final commit, merge, tag or Steam upload; in-game results remain pending.

### Required in-game acceptance

1. Hide clothing: both controls deactivate and the entire outfit disappears. Click helmet: both activate and the entire outfit returns. Hide clothing again, then click shirt: both return. Hide only headgear, then hide/show clothing: headgear stays hidden. Repeat several times and verify highlights match the rendered state.
2. Confirm actual equipment and map appearance stay unchanged; highlights and French/English tooltips describe the state and next action.
3. Rotate, zoom, switch pawn/corpse, close/reopen the tab and switch to vanilla view/back; both choices should survive during the session.
4. Check a pawn without clothing and an animal, tooltips and toolbar spacing, and absence of new rendering errors.

Preferences reset to visible on a new session. No save migration or persistent apparel changes are introduced. Custom portrait renderer compatibility remains unverified.

## 1.2.0

Status: validated locally after `r1`; milestone closed for publication.

### Automated evidence (2026-10-04)

- Verified the installed RimWorld 1.6 PortraitsCache.Get renderHeadgear argument and its participation in portrait cache equality.
- Project consistency and publication-ready checks passed for 1.2.0; final Release rebuild and package build passed with zero warnings and zero errors. Final archive: dist/NiceInventoryTab-AddOn-Preview-1.2.0.zip (930400 bytes, eight runtime files, Workshop ID verified).
- Clean archive: dist/NiceInventoryTab-AddOn-Preview-1.2.0-r1.zip (930400 bytes, eight runtime files).
- Staged into D:\SteamLibrary\steamapps\common\RimWorld\Mods\NiceInventoryTab-AddOn-Preview; all eight files match the archive by SHA-256.
- Previous local copy backed up in dist/local-backup-1.1.1-20261004-225930.zip.
- Workshop ID 3777164660 is preserved in the repository, package and installed copy.
- Maintainer confirmed the in-game tests OK on 2026-10-04. Acceptance is user-reported; the agent did not independently run the game or inspect Player.log. No Steam upload is claimed. Final publication-ready check, Release rebuild and package build passed with zero warnings/errors. The final ZIP contains eight runtime files (930763 bytes) and Workshop ID 3777164660.

### In-game acceptance coverage

The icon is highlighted when headgear is visible. The preference lasts for the current session and defaults to visible after restart.

- Test a pawn with a helmet, a pawn with a hat and a pawn without headgear.
- Toggle headgear off/on: only the preview changes; worn items and map appearance stay unchanged.
- Check all four rotations, zoom limits and selection of another pawn or corpse.
- Check a non-human pawn and confirm safe behavior when headgear is inapplicable.
- Switch to vanilla view and back, close/reopen the inventory and hide/show the preview; headgear preference should survive within the session.
- Check immediate portrait refresh, English/French tooltips and control spacing.
- Recheck the 1.1.1 vanilla-view width regression and absence of new rendering/Harmony errors.
- Run consistency, Release build and clean-package validation after the candidate is implemented; preserve Workshop ID 3777164660.

## 1.1.1

Status: validated locally after `r1`; milestone closed for publication.

### Evidence recorded on 2026-10-04

- Maintainer explicitly confirmed version 1.1.1 validated in game. The checklist below documents the acceptance scope; individual steps and Player.log were not independently rerun by the agent.
- Standard consistency check and publication-ready check passed; Release build passed with zero warnings and zero errors.
- package-mod.cmd passed its build and ZIP layout validation (929947 bytes, eight runtime files). The packaged Workshop ID is 3777164660; About/PublishedFileId.txt has no Git diff.
- Windows PowerShell initially could not resolve Get-FileHash because of the inherited module search path. Retrying with the standard Windows module path succeeded; no repository script change was needed.

### Automated and build validation

1. Run `tools/check-project-consistency.cmd -ExpectedVersion 1.1.1`.
2. Confirm `About/About.xml` and the project versions resolve to `1.1.1` / `1.1.1.0`.
3. Run `build.cmd` and confirm a successful Release build.
4. Run `package-mod.cmd` and confirm `dist/NiceInventoryTab-AddOn-Preview-1.1.1.zip` is created.
5. Confirm `About/PublishedFileId.txt` remains unchanged as `3777164660`.

### Vanilla-view regression test

6. Start RimWorld with Harmony, Nice Inventory Tab and the add-on enabled.
7. Select a pawn and open Nice Inventory Tab with the preview visible.
8. Use Nice Inventory Tab's own button to switch to RimWorld's vanilla gear view.
9. Confirm the preview disappears immediately with its reserved right-side width.
10. Confirm the vanilla gear view itself remains fully usable and is not covered by the add-on.
11. Switch back to Nice Inventory Tab and confirm the preview returns because the player's preview toggle was still enabled.
12. Change zoom and orientation, switch to vanilla and back, then confirm both states are preserved.
13. Hide the preview manually with the add-on toggle, switch to vanilla and back, and confirm the preview stays hidden.
14. Re-enable the preview and repeat the Nice/vanilla switch several times.
15. Confirm the tab width remains stable and never grows cumulatively.
16. Close and reopen the gear tab and confirm normal preview behavior remains unchanged.
17. Confirm no new red error or compatibility error appears in `Player.log`.

### Existing behavior regression

18. Preview still follows the selected pawn or corpse in Nice Inventory view.
19. Minus and plus still control zoom between 25% and 200%.
20. Left and right arrows still rotate through all four orientations.
21. Closing the inventory tab still removes the preview immediately.
22. The Equipment-to-preview spacing and close-button clearance remain unchanged.

### Known limitations

- The standard portrait renderer may omit the equipped weapon.
- Preview visibility, orientation and zoom are not persisted beyond the current session.
- Alternative portrait renderers have not received dedicated compatibility adaptations.
