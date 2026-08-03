# Current testing

## 1.0.0

Status: validated locally after `r3`; milestone closed for publication.

### Automated and release validation

1. `tools/check-project-consistency.cmd -ExpectedVersion 1.0.0` passed.
2. `About/About.xml` and the project versions resolve to `1.0.0` / `1.0.0.0`.
3. `About/Preview.png` and `docs/images/workshop-main.png` are `1280 × 720` and remain below 1 MB.
4. `docs/images/workshop-preview.png` remains the secondary in-game screenshot.
5. The stable publication procedure contains literal fast-forward commands for the release branch, `develop` and `main`.
6. The clean package and Workshop staging tools preserve the Workshop identifier.
7. The generated package excludes source, documentation, tools, PDB files and repository metadata.

### Functional validation baseline

8. The integrated preview behavior remains unchanged from the accepted `0.1.1-dev-r8` implementation.
9. The preview opens directly beside Nice Inventory Tab.
10. The visibility toggle expands and restores the tab width correctly.
11. The preview follows the selected pawn or corpse.
12. Left and right controls rotate through all four orientations.
13. Closing Nice Inventory Tab removes the preview immediately.
14. No overlap remains with the Equipment block or close control.

### Workshop publication validation

15. The first Workshop upload completed successfully.
16. Steam created item ID `3777164660`.
17. The published page is `https://steamcommunity.com/sharedfiles/filedetails/?id=3777164660`.
18. Steam's generated `About/PublishedFileId.txt` was copied into the repository.
19. The repository ID, staged ID and Workshop URL refer to the same item.
20. Future staging operations preserve the identifier so updates target the existing page.

### Known limitations

- The standard portrait renderer may omit the equipped weapon.
- Preview visibility and orientation are not persisted beyond the current session.
- Alternative portrait renderers have not received dedicated compatibility adaptations.
