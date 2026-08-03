# Current testing

## 0.1.0-dev

Status: validated locally after `r3`; milestone closed for publication.

Validation completed:

1. `build.cmd` completed a successful Release build.
2. `tools/check-project-consistency.cmd -ExpectedVersion 0.1.0-dev` passed.
3. `package-mod.cmd` accepted the Windows repository path after the quote-safe wrapper correction.
4. `dist/NiceInventoryTab-AddOn-Preview-0.1.0-dev.zip` was created successfully.
5. The generated archive used the single root folder `NiceInventoryTab-AddOn-Preview/`.
6. The package contained `About/About.xml`, `LoadFolders.xml` and `1.6/Assemblies/NiceInventoryTabAddOnPreview.dll`.
7. No source, documentation, tooling, debug symbol, nested ZIP or repository metadata entered the player-facing archive.
8. RimWorld loaded the add-on after Harmony and Nice Inventory Tab.
9. The log contained `[Nice Inventory Tab Add-on: Preview] Compatibility bootstrap initialized.`
10. Nice Inventory Tab opened and behaved normally without visible changes.
11. The local test pass completed without an add-on regression or red error.

Known limitation: this milestone intentionally does not display a pawn preview yet.

## Next validation target

`0.1.1-dev - Add rotatable pawn preview prototype`
