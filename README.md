# Nice Inventory Tab Add-on: Preview

RimWorld 1.6 add-on for **Nice Inventory Tab** that adds a rotatable preview of the selected equipped pawn without modifying the original mod.

![Integrated rotatable pawn preview](docs/images/workshop-preview.png)

## Project status

Latest validated milestone:

```text
0.1.1-dev - Add rotatable pawn preview prototype
```

The preview is integrated directly beside Nice Inventory Tab, disappears with the tab and follows the currently selected pawn or corpse. Two vanilla arrow controls rotate the portrait through all four orientations without changing the pawn's map rotation.

Next planned milestone:

```text
0.1.2-dev - Prepare initial Workshop release
```

## Requirements

- RimWorld 1.6
- Harmony
- Nice Inventory Tab
- .NET SDK capable of building `net472`

## Build

From the repository root:

```powershell
.\build.cmd
```

The default paths match the maintainer's current RimWorld installation. A different RimWorld Managed directory can be passed as the first argument.

```powershell
.\build.cmd "C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed"
```

The compiled assembly is written to `1.6/Assemblies/`.

## Clean RimWorld package

Build and generate the player-facing ZIP with:

```powershell
.\package-mod.cmd
```

The archive is written to `dist/` and contains only the installable mod folder. Source code, documentation, tools, screenshots, debug symbols and repository metadata are excluded and validated before success is reported.

See [`docs/PACKAGING.md`](docs/PACKAGING.md).

## Development workflow

- `main`: stable releases only, beginning with `1.0.0`.
- `develop`: latest validated development milestone.
- `feature/*`: one temporary feature milestone.
- `fix/*`: one temporary corrective milestone.
- Final milestone commits use `<version> - <description>`.
- Local revision suffixes such as `r1` are never used in commits or tags.
- Validated milestones are integrated into `develop` with `--ff-only` and receive one annotated `v<version>` tag.

See [`docs/BRANCHING_WORKFLOW.md`](docs/BRANCHING_WORKFLOW.md) and [`docs/MILESTONE_PUBLICATION.md`](docs/MILESTONE_PUBLICATION.md).
