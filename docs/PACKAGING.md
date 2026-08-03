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

For stable version `1.0.0`, the generated archive is:

```text
dist/NiceInventoryTab-AddOn-Preview-1.0.0.zip
```

Its installable layout is:

```text
NiceInventoryTab-AddOn-Preview/
├── About/
│   ├── About.xml
│   ├── ModIcon.png
│   ├── Preview.png
│   └── PublishedFileId.txt     # present only after the first Workshop upload
├── 1.6/
│   └── Assemblies/
│       └── NiceInventoryTabAddOnPreview.dll
├── Languages/
│   ├── English/Keyed/NiceInventoryTabAddOnPreview.xml
│   └── French/Keyed/NiceInventoryTabAddOnPreview.xml
└── LoadFolders.xml
```

The package requires `About/Preview.png`, validates that it is `640 × 360` or `1280 × 720`, and rejects it when it reaches Steam's 1 MB preview limit.

Optional runtime directories such as `Languages`, `Textures`, `Defs` and `Patches` are included automatically when they exist.

## Workshop staging

```powershell
.\stage-workshop.cmd
```

This command:

1. builds and validates the same clean ZIP;
2. extracts it into RimWorld's local `Mods` directory;
3. replaces only the generated add-on folder;
4. preserves an existing `About/PublishedFileId.txt`;
5. refuses to overwrite a conflicting Workshop identifier.

The default target is:

```text
D:\SteamLibrary\steamapps\common\RimWorld\Mods\NiceInventoryTab-AddOn-Preview
```

## Exclusions

The generated archive rejects development content, including:

- `Source`, `docs`, `tools` and `dist`;
- Git and editor metadata;
- build intermediates;
- C# source and project files;
- PDB, patch and nested ZIP files;
- placeholder `.gitkeep` files;
- the full documentation screenshot under `docs/images`.

The generator reopens the completed ZIP and validates its required entries before reporting success.
