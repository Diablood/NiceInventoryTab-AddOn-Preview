# Current testing

## 0.1.0-dev

Status: awaiting local validation.

Required checks:

1. Run `build.cmd` and confirm a successful Release build.
2. Run `tools/check-project-consistency.cmd -ExpectedVersion 0.1.0-dev`.
3. Start RimWorld with Harmony, Nice Inventory Tab and this add-on enabled.
4. Confirm the log contains `Compatibility bootstrap initialized` exactly once.
5. Open a colonist's gear tab and confirm Nice Inventory Tab behaves unchanged.
6. Save and reload once; confirm no red error is introduced.

Expected limitation: this milestone does not display a pawn preview yet.
