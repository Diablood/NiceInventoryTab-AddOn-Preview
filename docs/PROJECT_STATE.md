# Project state

## Current milestone

- Version: `1.3.0`
- Name: Add apparel preview toggle
- Branch: `feature/apparel-preview-toggle`
- Base: `v1.2.0` (`d909f7c`), verified on remote main and develop.
- Status: validated and closed
- Validated local revision: `r3`
- Tag: `v1.3.0`
- Runtime metadata: `1.3.0` / `1.3.0.0`.
- Workshop ID: `3777164660`
- Workshop URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3777164660

## Implementation

- Linked controls: hiding clothing hides headgear too; showing headgear while clothing is hidden restores the whole outfit. Showing clothing restores the remembered headgear preference. Highlights and action tooltips reflect these transitions.
- Both default to visible and retain their choices during the session, including zoom, rotation, pawn selection, tab reopen and vanilla view switching.
- Use the installed RimWorld 1.6 PortraitsCache.Get renderClothes parameter and the Core Apparel_BasicShirt icon.
- Four 38-pixel controls and three 12-pixel gaps occupy 188 pixels of the existing 222-pixel toolbar; panel size is unchanged.
- Highlight enabled controls and translate action tooltips in English and French.
- Do not change actual worn apparel, map rendering, save data or Nice Inventory Tab itself.

## Last closed milestone

- Version: `1.2.0`
- Tag: `v1.2.0`
- Status: validated and closed
- Commit: `d909f7c`
- Headgear toggle validated in game by the maintainer; main, develop and the annotated tag were verified on GitHub.
- Git publication does not assert a Steam upload.

## Validation

See TESTING_CURRENT.md for automated evidence and the linked-control transition tests. Maintainer confirmed r3 tests OK on 2026-10-04, including restoration of the remembered headgear preference.
