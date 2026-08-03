# Current testing

## 0.1.1-dev

Status: validated locally after `r8`; milestone closed for publication.

### Automated and build validation

1. `tools/check-project-consistency.cmd -ExpectedVersion 0.1.1-dev` passed.
2. The project versions matched `0.1.1.0`.
3. The compatibility and preview source guards passed.
4. `build.cmd` completed a successful Release build.
5. `package-mod.cmd` created `dist/NiceInventoryTab-AddOn-Preview-0.1.1-dev.zip`.
6. The clean archive contained the runtime mod files and excluded source, documentation, tooling and screenshots.

### Startup and compatibility validation

7. Harmony, Nice Inventory Tab and the add-on loaded in the required order.
8. The log contained the compatibility-bootstrap and integrated-preview initialization messages.
9. No compatibility-signature failure or red startup error occurred.
10. Nice Inventory Tab remained functional when the preview was visible or hidden.

### Functional validation

11. The preview rendered directly beside Nice Inventory Tab rather than in a popup.
12. Closing the inventory tab removed the preview immediately.
13. Hiding and showing the preview restored and expanded the tab width correctly.
14. The width remained stable over repeated draw frames.
15. The preview followed the selected living pawn and supported corpse selection.
16. All four orientations rendered without changing the pawn's actual map rotation.
17. The left arrow rotated clockwise and the right arrow rotated counterclockwise.
18. The English and French tooltips matched those actions.

### Final presentation validation

19. The preview began below the inventory-tab close control.
20. The redundant pawn name and cardinal-direction labels were absent.
21. The outer command-area background and inner portrait background were accepted.
22. The current portrait scale was accepted for the prototype.
23. The final `PanelGap = 0f` reused Nice Inventory Tab's own right margin.
24. The Equipment-to-preview spacing visually matched the Clothing-to-Equipment spacing.
25. The preview border did not overlap the Equipment block.
26. The final representative screenshot was captured as `docs/images/workshop-preview.png`.

### Known limitations

- The standard portrait renderer may omit the equipped weapon.
- Preview visibility and orientation are not persisted beyond the current session.
- Alternative portrait renderers have not received dedicated compatibility adaptations.

## Next validation target

```text
0.1.2-dev - Prepare initial Workshop release
```
