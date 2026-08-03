# Clean RimWorld package

## Purpose

The repository contains source code, tests and project documentation that must not be shipped in the player-facing mod archive. The package generator builds the Release assembly and creates a clean RimWorld ZIP from a runtime allowlist.

## Command

From the repository root:

```powershell
.\package-mod.cmd
```

A different RimWorld Managed directory can be supplied when necessary:

```powershell
.\package-mod.cmd -RimWorldManagedDir "C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed"
```

To package an already built assembly without rebuilding:

```powershell
.\package-mod.cmd -SkipBuild
```

## Output

For version `0.1.0-dev`, the generated archive is:

```text
 dist/NiceInventoryTab-AddOn-Preview-0.1.0-dev.zip
```

Its installable layout is:

```text
NiceInventoryTab-AddOn-Preview/
├── About/
│   └── About.xml
├── 1.6/
│   └── Assemblies/
│       └── NiceInventoryTabAddOnPreview.dll
└── LoadFolders.xml
```

Optional runtime directories such as `Languages`, `Textures`, `Defs` and `Patches` are included automatically when they exist.

## Exclusions

The generated archive rejects development content, including:

- `Source`, `docs`, `tools` and `dist`;
- Git and editor metadata;
- build intermediates;
- C# source and project files;
- PDB, patch and nested ZIP files;
- placeholder `.gitkeep` files.

The generator also reopens the completed ZIP and validates its required entries before reporting success.
