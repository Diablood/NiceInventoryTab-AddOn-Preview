# Current testing

## 1.1.0

Status: validated locally after `r3`; milestone closed for publication.

### Automated and release validation

1. `tools/check-project-consistency.cmd -ExpectedVersion 1.1.0` passed.
2. `tools/check-project-consistency.cmd -ExpectedVersion 1.1.0 -RequirePublicationReady` passed.
3. `About/About.xml` and the project versions resolve to `1.1.0` / `1.1.0.0`.
4. The Release build completed with zero warnings and zero errors.
5. The clean `1.1.0` package passed its runtime allowlist and ZIP-layout validation.
6. `About/About.xml` omits the unsupported top-level `steamWorkshopUrl` element.
7. `About/PublishedFileId.txt` remains unchanged as `3777164660`.

### Functional validation

8. The preview opens directly beside Nice Inventory Tab and follows the selected pawn or corpse.
9. Vanilla minus and plus buttons appear at the top of the preview panel.
10. Minus zooms out and plus zooms in from the unchanged 100% default.
11. Zoom remains bounded between 25% and 200%.
12. A Thrumbo can be reduced until its visible body fits inside the preview.
13. RimWorld's vanilla `+0.3` camera offset lowers the animal and keeps its head in frame at closer zoom levels.
14. Left and right controls continue to rotate through all four orientations.
15. The visibility toggle continues to expand and restore the tab width correctly.
16. Closing Nice Inventory Tab removes the preview immediately.
17. No overlap occurs with the Equipment block or close control.

### Startup and update validation

18. RimWorld no longer reports the add-on's invalid root Workshop metadata at startup.
19. The compatibility bootstrap initializes and attaches the integrated preview.
20. The existing Workshop item ID and URL still agree.
21. Package generation preserves the identifier so the update targets item `3777164660`.

### Known limitations

- The standard portrait renderer may omit the equipped weapon.
- Preview visibility, orientation and zoom are not persisted beyond the current session.
- Alternative portrait renderers have not received dedicated compatibility adaptations.
