# Nice Inventory Tab Add-on: Preview

RimWorld 1.6 add-on for **Nice Inventory Tab** that will add a rotatable preview of the selected equipped pawn.

## Current milestone

`0.1.0-dev - Establish project foundation`

This first milestone provides the repository structure, build configuration, compatibility bootstrap, project documentation and consistency checks. The visible pawn preview is deliberately reserved for the next functional milestone.

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

## Development workflow

- `main`: stable releases only, beginning with `1.0.0`.
- `develop`: latest validated development milestone.
- `feature/*`: one temporary feature milestone.
- `fix/*`: one temporary corrective milestone.
- Final milestone commits use `<version> - <description>`.
- Local revision suffixes such as `r1` are never used in commits or tags.
- Validated milestones are integrated into `develop` with `--ff-only` and receive one annotated `v<version>` tag.

See [`docs/BRANCHING_WORKFLOW.md`](docs/BRANCHING_WORKFLOW.md) and [`docs/MILESTONE_PUBLICATION.md`](docs/MILESTONE_PUBLICATION.md).
