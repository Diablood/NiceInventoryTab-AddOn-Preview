# Roadmap

## Validated milestones

### 0.1.0-dev - Establish project foundation

Validated after local revision `r3`.

- Create the repository and RimWorld 1.6 mod structure.
- Add the build, compatibility bootstrap and rotation-state foundation.
- Add project workflow, testing and consistency documentation.
- Add a clean final-package generator with validated ZIP layout.

## Active sequence

### 0.1.1-dev - Add rotatable pawn preview prototype

- Validate the exact Nice Inventory Tab `Prefix` and `AddonCheckBoxes` targets.
- Disable the preview safely when the expected compatibility surface is unavailable.
- Add an optional equipped-pawn preview without modifying Nice Inventory Tab.
- Render the selected pawn using the standard RimWorld portrait system.
- Add clockwise and counterclockwise controls for all four orientations.
- Keep the original inventory interface functional when the preview is hidden or unavailable.

### 0.1.2-dev - Finalize preview integration

- Refine panel dimensions and positioning.
- Persist visibility and orientation preferences when useful.
- Add English and French player-facing text.
- Complete compatibility and regression tests.
- Prepare the first stable release if no additional functional work is required.

## Later evaluation

These features are optional and must not delay the core add-on:

- Weapon rendering.
- Mouse drag or mouse-wheel rotation.
- Zoom controls.
- Compatibility adaptations for custom races, facial animation and alternative pawn renderers.
