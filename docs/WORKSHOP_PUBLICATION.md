# Steam Workshop publication

## Published item

- Title: `Nice Inventory Tab Add-on: Preview`
- Version: `1.0.0`
- Workshop ID: `3777164660`
- Workshop URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3777164660
- Identifier file: `About/PublishedFileId.txt`

The initial upload is complete. The identifier file is now a permanent release artifact and must remain unchanged for every future update.

## Workshop image set

Use the two prepared images in this order:

1. `docs/images/workshop-main.png` — primary promotional image with the mod title and RimWorld `1.6` badge. The same image is stored as `About/Preview.png`.
2. `docs/images/workshop-preview.png` — secondary in-game screenshot showing the actual integrated result.

## Build and stage the clean local mod

From the repository root:

```powershell
.\tools\check-project-consistency.cmd -ExpectedVersion 1.0.0
.\tools\check-project-consistency.cmd -ExpectedVersion 1.0.0 -RequirePublicationReady
.\build.cmd
.\package-mod.cmd
.\stage-workshop.cmd
```

Default staged location:

```text
D:\SteamLibrary\steamapps\common\RimWorld\Mods\NiceInventoryTab-AddOn-Preview
```

The staging process is generated from the validated clean ZIP. It preserves `About/PublishedFileId.txt` and refuses to continue if the repository and staged identifiers disagree.

## Finalize the stable release in Git

Commit the validated release branch:

```powershell
git add -A
git diff --cached --check
git commit -m "1.0.0 - Publish initial Workshop release"
```

Fast-forward the validated release branch into `develop`:

```powershell
git switch develop
git pull --ff-only origin develop
git merge --ff-only feature/initial-workshop-release
git push origin develop
```

Fast-forward the stable branch from `develop`:

```powershell
git switch main
git pull --ff-only origin main
git merge --ff-only develop
git push origin main
```

Create and push the unique annotated stable tag:

```powershell
git tag -a v1.0.0 -m "1.0.0 - Publish initial Workshop release"
git push origin v1.0.0
```

Verify that `develop`, `main` and `v1.0.0` resolve to the same commit.

## Future Workshop updates

- Never remove, replace or regenerate `About/PublishedFileId.txt`.
- Run `stage-workshop.cmd`; it preserves item ID `3777164660` in the local upload folder.
- Use RimWorld's Workshop update action rather than creating a new item.
- Confirm the Workshop URL still points to item `3777164660` before publishing an update.
