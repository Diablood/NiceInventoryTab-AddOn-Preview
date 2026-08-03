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

## Later evaluation

These features are optional and will be considered only when a concrete need appears:

- Weapon rendering when the standard portrait omits the equipped weapon.
- Mouse drag or mouse-wheel rotation.
- Zoom controls.
- Persistent preview preferences.
- Compatibility adaptations for custom races, facial animation and alternative pawn renderers.
