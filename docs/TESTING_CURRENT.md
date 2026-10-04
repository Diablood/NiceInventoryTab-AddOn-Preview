# Current testing

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

## Next milestone after validation

```text
1.2.0 - Add headgear preview toggle
```
