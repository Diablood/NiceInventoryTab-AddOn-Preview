# Project state

## Current milestone

- Version: `1.2.0`
- Name: Add headgear preview toggle
- Branch: `feature/headgear-preview-toggle`
- Base: `v1.1.1` (`476927f`), verified on remote `main` and `develop`.
- Status: validated and closed
- Validated local revision: `r1`
- Tag: `v1.2.0`
- Runtime metadata: `1.2.0` / `1.2.0.0`.

### Implementation scope

- Add one preview-only show/hide helmets and hats button, initially showing headgear.
- Verified the installed RimWorld 1.6 PortraitsCache.Get signature and cache parameters: renderHeadgear is supported and included in portrait cache selection. The implementation passes ShowHeadgear directly to this call.
- Keep state with the existing preview state and preserve it across rotation, zoom, pawn selection and temporary vanilla view switches for the current session.
- Use the Core Apparel_SimpleHelmet uiIcon, highlight the enabled state and provide English/French action tooltips with a localized text fallback.
- Never modify actual worn apparel, equipment, map rendering or Nice Inventory Tab itself.
- Keep the clothing toggle entirely in milestone `1.3.0`.
- Maintainer confirmed in-game tests OK on 2026-10-04 for local revision r1; automated release checks are recorded in TESTING_CURRENT.md.

## Last closed milestone

- Version: `1.1.1`
- Name: Hide preview in vanilla inventory view
- Branch: `fix/vanilla-view-preview-visibility`
- Base: `v1.1.0`
- Tag: `v1.1.1`
- Status: validated and closed
- Validated local revision: `r1`
- Workshop ID: `3777164660`
- Workshop URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3777164660

## Scope of this corrective milestone

- Detect when Nice Inventory Tab's Harmony prefix allows RimWorld's vanilla `ITab_Pawn_Gear.FillTab` to run.
- Suppress the integrated preview while the vanilla gear view is active.
- Release the preview's reserved width before the vanilla view is drawn.
- Preserve the player's preview visibility choice while switching between Nice Inventory Tab and vanilla view.
- Preserve the current preview rotation and zoom while the host mod is temporarily in vanilla mode.
- Leave Nice Inventory Tab's own toggle behavior and assembly untouched.

## Implementation approach

Nice Inventory Tab already exposes the required state through the return value of its validated `Prefix(ITab_Pawn_Gear, ref Vector2)` method. As a Harmony prefix, a `true` result means RimWorld's original `FillTab` is allowed to continue. The add-on therefore reads the patched method's `__result` in its postfix and draws the preview only when the result is `false`.

This avoids reflection against a private Nice Inventory Tab field and keeps the compatibility surface limited to the method signature already validated by the add-on.

## Validation coverage

In-game acceptance reported by the maintainer on 2026-10-04. Release build and clean package generation passed on the same date; detailed evidence is recorded in TESTING_CURRENT.md. Workshop upload of this patch is not asserted by Git publication.

- Project consistency check for `1.1.1`.
- Release build.
- Clean package generation.
- Open Nice Inventory Tab with the preview visible.
- Switch to Nice Inventory Tab's vanilla view and confirm the preview and its extra width disappear.
- Switch back to Nice Inventory Tab and confirm the preview returns when it was previously enabled.
- Repeat the test after manually hiding the preview and confirm it remains hidden when returning from vanilla view.
- Confirm rotation and zoom state survive the temporary vanilla-view switch.
- Repeat the view switch several times and confirm no width accumulation or overlap occurs.
- Confirm no new red error appears in `Player.log`.

## Milestone sequence

Closed milestones:

```text
1.2.0 - Add headgear preview toggle
```

Then, only after `1.2.0` is closed:

```text
1.3.0 - Add apparel preview toggle
```

The three changes remain separate milestones and separate final tags.
