# Roadmap

## Validated milestones

### 0.1.0-dev - Establish project foundation

Validated after local revision `r3` and published as `v0.1.0-dev`.

- Create the repository and RimWorld 1.6 mod structure.
- Add the build, compatibility bootstrap and rotation-state foundation.
- Add project workflow, testing and consistency documentation.
- Add a clean final-package generator with validated ZIP layout.

### 0.1.1-dev - Add rotatable pawn preview prototype

Validated after local revision `r8` and ready for publication as `v0.1.1-dev`.

- Validate the exact Nice Inventory Tab compatibility hooks.
- Disable the add-on safely when the expected compatibility surface is unavailable.
- Add an optional preview toggle through the original mod's empty extension hook.
- Integrate the portrait directly beside the inventory contents.
- Link preview lifetime and width to Nice Inventory Tab.
- Render the selected pawn or corpse with RimWorld's standard portrait system.
- Add vanilla left and right rotation controls with localized tooltips.
- Remove cardinal labels, duplicated pawn names and detached-window state.
- Align the final panel spacing, backgrounds and close-control clearance with the host interface.

## Planned milestone

### 0.1.2-dev - Prepare initial Workshop release

- Finalize the English and French Workshop description.
- Reuse `docs/images/workshop-preview.png` as the representative release image.
- Verify the dependency and load-order presentation.
- Install the generated ZIP into a clean RimWorld mod directory and perform a release smoke test.
- Decide whether to publish another development tag or promote the validated add-on to `1.0.0`.
- Record the Workshop publication identifier only after the first upload exists.

## Later evaluation

These features are optional and must not delay the initial release:

- Weapon rendering when the standard portrait omits the equipped weapon.
- Mouse drag or mouse-wheel rotation.
- Zoom controls.
- Persistent preview preferences.
- Compatibility adaptations for custom races, facial animation and alternative pawn renderers.
