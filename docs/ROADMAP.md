# Roadmap

## Validated milestones

### 0.1.0-dev - Establish project foundation

Validated after local revision `r3` and published as `v0.1.0-dev`.

- Create the repository and RimWorld 1.6 mod structure.
- Add the build, compatibility bootstrap and rotation-state foundation.
- Add project workflow, testing and consistency documentation.
- Add a clean final-package generator with validated ZIP layout.

### 0.1.1-dev - Add rotatable pawn preview prototype

Validated after local revision `r8` and published as `v0.1.1-dev`.

- Validate the exact Nice Inventory Tab compatibility hooks.
- Disable the add-on safely when the expected compatibility surface is unavailable.
- Add an optional preview toggle through the original mod's empty extension hook.
- Integrate the portrait directly beside the inventory contents.
- Link preview lifetime and width to Nice Inventory Tab.
- Render the selected pawn or corpse with RimWorld's standard portrait system.
- Add vanilla left and right rotation controls with localized tooltips.
- Align the final panel spacing, backgrounds and close-control clearance with the host interface.

### 1.0.0 - Initial Workshop release

Validated after release preparation revision `r3` and published to Workshop item `3777164660`.

- Promote the accepted preview to the first stable release.
- Add the primary promotional image and secondary in-game screenshot.
- Finalize the bilingual Workshop description and stable metadata.
- Add clean package and Workshop staging workflows.
- Preserve Steam's real `About/PublishedFileId.txt` for future updates.
- Record the Workshop URL and stable publication process.
- Integrate the validated release into `develop`, then fast-forward `main`.
- Publish the unique annotated tag `v1.0.0`.

### 1.1.0 - Add zoom controls

Validated in game after local revision `r3` and published as `v1.1.0`.

- Add vanilla minus and plus controls at the top of the preview panel.
- Support zoom levels from 25% to 200% while preserving the original 100% default.
- Apply RimWorld's vanilla portrait camera offset so tall animals remain framed around their visible body.
- Validate zooming and framing with a Thrumbo while preserving rotation and visibility behavior.
- Remove unsupported top-level Workshop metadata that produced a RimWorld 1.6 startup XML error.
- Refresh the primary Workshop image while preserving its existing composition.
- Replace the secondary image with the final in-game screenshot showing the zoom controls.
- Preserve the existing Workshop item identifier for the update.

### 1.1.1 - Hide preview in vanilla inventory view

Validated in game after local revision `r1`; closed for publication as `v1.1.1` from `fix/vanilla-view-preview-visibility`.

- Use Nice Inventory Tab's existing Harmony-prefix return value to distinguish its custom view from RimWorld's vanilla gear view.
- Remove the preview and its reserved width whenever vanilla `ITab_Pawn_Gear.FillTab` is allowed to run.
- Preserve the player's preview visibility, rotation and zoom state while switching views.
- Confirm repeated switching never accumulates width or affects Nice Inventory Tab's own toggle.

### 1.2.0 - Add headgear preview toggle

Validated in game after local revision `r1`; closed for publication as `v1.2.0` from `feature/headgear-preview-toggle`.

- Add a preview-only control for showing or hiding helmets and hats.
- Prefer a clear vanilla icon when available.
- Do not alter the pawn's actual apparel or equipment state.

## Planned milestones

### 1.3.0 - Add apparel preview toggle

Start only after `1.2.0` is validated, published and tagged.

- Add a separate preview-only control for showing or hiding worn apparel.
- Keep headgear control behavior independent.
- Do not alter the pawn's actual apparel or equipment state.

## Later evaluation

These features are optional and will be considered only when a concrete need appears:

- Weapon rendering when the standard portrait omits the equipped weapon.
- Mouse drag or mouse-wheel rotation.
- Persistent preview preferences.
- Compatibility adaptations for custom races, facial animation and alternative pawn renderers.
