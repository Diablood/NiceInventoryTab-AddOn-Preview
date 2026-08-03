[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [string]$ExpectedVersion,
    [switch]$RequirePublicationReady
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Join-Path $PSScriptRoot ".."
}

$RepositoryRoot = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$failures = New-Object System.Collections.Generic.List[string]

function Pass([string]$Message) {
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Fail([string]$Message) {
    [void]$failures.Add($Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Read-Text([string]$RelativePath) {
    $path = Join-Path $RepositoryRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return $null
    }

    return Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

function Assert-Contains {
    param(
        [string]$Text,
        [string]$Fragment,
        [string]$Description
    )

    if ($null -ne $Text -and $Text.Contains($Fragment)) {
        Pass "$Description contains '$Fragment'."
    }
    else {
        Fail "$Description is missing '$Fragment'."
    }
}

function Test-WorkshopPreview {
    param([string]$RelativePath)

    $path = Join-Path $RepositoryRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Fail "Missing Workshop preview: $RelativePath"
        return
    }

    $file = Get-Item -LiteralPath $path
    if ($file.Length -lt 1MB) {
        Pass "Workshop preview remains below 1 MB: $($file.Length) bytes."
    }
    else {
        Fail "Workshop preview is $($file.Length) bytes; it must remain below 1 MB."
    }

    try {
        Add-Type -AssemblyName System.Drawing
        $image = [System.Drawing.Image]::FromFile($path)
        try {
            $validSize =
                ($image.Width -eq 640 -and $image.Height -eq 360) -or
                ($image.Width -eq 1280 -and $image.Height -eq 720)

            if ($validSize) {
                Pass "Workshop preview dimensions are $($image.Width)x$($image.Height)."
            }
            else {
                Fail "Workshop preview dimensions are $($image.Width)x$($image.Height); expected 640x360 or 1280x720."
            }
        }
        finally {
            $image.Dispose()
        }
    }
    catch {
        Fail "Could not inspect Workshop preview: $($_.Exception.Message)"
    }
}

Write-Host "Nice Inventory Tab Add-on: Preview consistency check"
Write-Host "Repository: $RepositoryRoot"
Write-Host ""

$markdownFiles = @()
$readmePath = Join-Path $RepositoryRoot "README.md"
if (Test-Path -LiteralPath $readmePath -PathType Leaf) {
    $markdownFiles += Get-Item -LiteralPath $readmePath
}

$docsPath = Join-Path $RepositoryRoot "docs"
if (Test-Path -LiteralPath $docsPath -PathType Container) {
    $markdownFiles += Get-ChildItem -LiteralPath $docsPath -Filter "*.md" -File -Recurse
}

$tabFiles = @()
foreach ($file in $markdownFiles) {
    if ((Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8).Contains("`t")) {
        $tabFiles += $file.FullName
    }
}

if ($tabFiles.Count -eq 0) {
    Pass "Markdown files contain no literal tab characters."
}
else {
    Fail "Literal tabs found: $($tabFiles -join ', ')"
}

$required = @(
    "About/About.xml",
    "About/Preview.png",
    "About/ModIcon.png",
    "LoadFolders.xml",
    "Source/NiceInventoryTabAddOnPreview/NiceInventoryTabAddOnPreview.csproj",
    "Source/NiceInventoryTabAddOnPreview/Bootstrap.cs",
    "Source/NiceInventoryTabAddOnPreview/CompatibilityTargets.cs",
    "Source/NiceInventoryTabAddOnPreview/PreviewState.cs",
    "Source/NiceInventoryTabAddOnPreview/PreviewTogglePatch.cs",
    "Source/NiceInventoryTabAddOnPreview/PreviewPanelPatch.cs",
    "Languages/English/Keyed/NiceInventoryTabAddOnPreview.xml",
    "Languages/French/Keyed/NiceInventoryTabAddOnPreview.xml",
    "package-mod.cmd",
    "stage-workshop.cmd",
    "tools/package-mod.ps1",
    "tools/stage-workshop.ps1",
    "docs/PACKAGING.md",
    "docs/WORKSHOP_DESCRIPTION.md",
    "docs/WORKSHOP_PUBLICATION.md",
    "docs/PROJECT_STATE.md",
    "docs/ROADMAP.md",
    "docs/TESTING_CURRENT.md",
    "docs/TESTING.md",
    "docs/CHANGELOG.md",
    "docs/images/workshop-main.png",
    "docs/images/workshop-preview.png"
)

foreach ($relative in $required) {
    if (Test-Path -LiteralPath (Join-Path $RepositoryRoot $relative) -PathType Leaf) {
        Pass "Required file exists: $relative"
    }
    else {
        Fail "Missing required file: $relative"
    }
}

$aboutPath = Join-Path $RepositoryRoot "About/About.xml"
$about = $null
$version = $null

try {
    [xml]$about = Get-Content -LiteralPath $aboutPath -Raw -Encoding UTF8
    $version = [string]$about.ModMetaData.modVersion
}
catch {
    Fail "About/About.xml is invalid: $($_.Exception.Message)"
}

if (-not [string]::IsNullOrWhiteSpace($version) -and
    $version -match '^\d+\.\d+\.\d+(-dev)?$') {
    Pass "About mod version is '$version'."
}
else {
    Fail "Invalid mod version '$version'."
}

if (-not [string]::IsNullOrWhiteSpace($ExpectedVersion)) {
    if ($version -eq $ExpectedVersion) {
        Pass "Requested milestone version matches '$ExpectedVersion'."
    }
    else {
        Fail "Requested version is '$ExpectedVersion' but About uses '$version'."
    }
}

$numeric = $null
if ($version -match '^(?<base>\d+\.\d+\.\d+)(?:-dev)?$') {
    $numeric = "$($Matches['base']).0"
}

$projectPath = Join-Path $RepositoryRoot "Source/NiceInventoryTabAddOnPreview/NiceInventoryTabAddOnPreview.csproj"
$project = $null
try {
    [xml]$project = Get-Content -LiteralPath $projectPath -Raw -Encoding UTF8
}
catch {
    Fail "C# project XML is invalid: $($_.Exception.Message)"
}

if ($null -ne $project -and -not [string]::IsNullOrWhiteSpace($numeric)) {
    $group = @($project.Project.PropertyGroup) | Where-Object { $_.Version } | Select-Object -First 1
    foreach ($name in @("Version", "AssemblyVersion", "FileVersion")) {
        $value = [string]$group.$name
        if ($value -eq $numeric) {
            Pass "$name matches '$numeric'."
        }
        else {
            Fail "$name is '$value'; expected '$numeric'."
        }
    }

    $referenceNames = @($project.Project.ItemGroup.Reference | ForEach-Object { [string]$_.Include })
    if ($referenceNames -contains "UnityEngine.TextRenderingModule") {
        Pass "UnityEngine.TextRenderingModule reference is declared."
    }
    else {
        Fail "Missing UnityEngine.TextRenderingModule project reference."
    }
}

Test-WorkshopPreview -RelativePath "About/Preview.png"
Test-WorkshopPreview -RelativePath "docs/images/workshop-main.png"

$gitignorePath = Join-Path $RepositoryRoot ".gitignore"
if (Test-Path -LiteralPath $gitignorePath -PathType Leaf) {
    $gitignoreEntries = @(Get-Content -LiteralPath $gitignorePath -Encoding UTF8 | ForEach-Object { $_.Trim() })
    if ($gitignoreEntries -contains "dist/") {
        Pass "Generated package directory is ignored."
    }
    else {
        Fail "Missing dist/ entry in .gitignore."
    }
}
else {
    Fail "Missing required file: .gitignore"
}

$packageWrapperText = Read-Text "package-mod.cmd"
Assert-Contains -Text $packageWrapperText -Fragment '-RepositoryRoot "%~dp0."' -Description "Package wrapper"

$stageWrapperText = Read-Text "stage-workshop.cmd"
Assert-Contains -Text $stageWrapperText -Fragment '-RepositoryRoot "%~dp0."' -Description "Workshop staging wrapper"
Assert-Contains -Text $stageWrapperText -Fragment 'tools\stage-workshop.ps1' -Description "Workshop staging wrapper"

$packageScriptText = Read-Text "tools/package-mod.ps1"
foreach ($expectedFragment in @(
    "NiceInventoryTab-AddOn-Preview",
    "NiceInventoryTabAddOnPreview.dll",
    "About/Preview.png",
    "Assert-WorkshopPreview",
    "CreateFromDirectory",
    "OpenRead"
)) {
    Assert-Contains -Text $packageScriptText -Fragment $expectedFragment -Description "Package generator"
}

$stageScriptText = Read-Text "tools/stage-workshop.ps1"
foreach ($expectedFragment in @(
    "PublishedFileId.txt",
    "Workshop ID mismatch",
    "package-mod.ps1",
    "Expand-Archive",
    "D:\SteamLibrary\steamapps\common\RimWorld\Mods"
)) {
    Assert-Contains -Text $stageScriptText -Fragment $expectedFragment -Description "Workshop staging generator"
}

$bootstrapPath = Join-Path $RepositoryRoot "Source/NiceInventoryTabAddOnPreview/Bootstrap.cs"
$compatibilityPath = Join-Path $RepositoryRoot "Source/NiceInventoryTabAddOnPreview/CompatibilityTargets.cs"
$togglePatchPath = Join-Path $RepositoryRoot "Source/NiceInventoryTabAddOnPreview/PreviewTogglePatch.cs"
$previewPanelPath = Join-Path $RepositoryRoot "Source/NiceInventoryTabAddOnPreview/PreviewPanelPatch.cs"

foreach ($sourceCheck in @(
    @{ Path = $bootstrapPath; Fragments = @("CompatibilityTargets.TryValidate", "PreviewTogglePatch", "PreviewPanelPatch.Prefix", "PreviewPanelPatch.Postfix", "harmony.Patch") },
    @{ Path = $compatibilityPath; Fragments = @("MatchesPrefixSignature", "MatchesAddonCheckBoxesSignature", "MakeByRefType") },
    @{ Path = $togglePatchPath; Fragments = @("DrawToggle", "PreviewState.ToggleVisibility", "NITAP_PreviewToggle") },
    @{ Path = $previewPanelPath; Fragments = @("ref Vector2 __1", "RestorePreviouslyExpandedWidth", "previousExpandedWidth", "PanelGap = 0f", "PanelTopInset", "Widgets.DrawWindowBackground", "Widgets.DrawMenuSection", "PortraitsCache.Get", "TexUI.ArrowTexLeft", "TexUI.ArrowTexRight", "RotateCounterclockwise", "RotateClockwise") }
)) {
    if (-not (Test-Path -LiteralPath $sourceCheck.Path -PathType Leaf)) {
        continue
    }

    $sourceText = Get-Content -LiteralPath $sourceCheck.Path -Raw -Encoding UTF8
    foreach ($fragment in $sourceCheck.Fragments) {
        if ($sourceText.Contains($fragment)) {
            Pass "Preview source contains '$fragment'."
        }
        else {
            Fail "Preview source is missing '$fragment'."
        }
    }
}

foreach ($obsoleteRotationTexture in @(
    "Textures/NiceInventoryTabAddOnPreview/RotateCounterclockwise.png",
    "Textures/NiceInventoryTabAddOnPreview/RotateClockwise.png"
)) {
    if (Test-Path -LiteralPath (Join-Path $RepositoryRoot $obsoleteRotationTexture)) {
        Fail "Obsolete custom rotation texture still exists: $obsoleteRotationTexture"
    }
    else {
        Pass "Obsolete custom rotation texture is absent: $obsoleteRotationTexture"
    }
}

foreach ($obsoletePreviewFile in @(
    "Source/NiceInventoryTabAddOnPreview/PreviewWindow.cs",
    "Source/NiceInventoryTabAddOnPreview/PreviewWindowController.cs",
    "Source/NiceInventoryTabAddOnPreview/PreviewTabSizePatch.cs"
)) {
    if (Test-Path -LiteralPath (Join-Path $RepositoryRoot $obsoletePreviewFile)) {
        Fail "Obsolete preview source still exists: $obsoletePreviewFile"
    }
    else {
        Pass "Obsolete preview source is absent: $obsoletePreviewFile"
    }
}

foreach ($forbiddenPreviewFragment in @(
    "nameof(ITab.Size)",
    "CompatibilityTargets.TabSizeGetter",
    "tab.Size"
)) {
    $fragmentFound = $false
    foreach ($previewSourcePath in @($bootstrapPath, $compatibilityPath, $previewPanelPath)) {
        if (-not (Test-Path -LiteralPath $previewSourcePath -PathType Leaf)) {
            continue
        }

        $previewSourceText = Get-Content -LiteralPath $previewSourcePath -Raw -Encoding UTF8
        if ($previewSourceText.Contains($forbiddenPreviewFragment)) {
            $fragmentFound = $true
            break
        }
    }

    if ($fragmentFound) {
        Fail "Obsolete ITab size API reference remains: $forbiddenPreviewFragment"
    }
    else {
        Pass "Obsolete ITab size API reference is absent: $forbiddenPreviewFragment"
    }
}

foreach ($forbiddenPresentationFragment in @(
    "pawn.LabelShortCap",
    "NITAP_PreviewTitle",
    "NiceInventoryTabAddOnPreview/RotateCounterclockwise",
    "NiceInventoryTabAddOnPreview/RotateClockwise"
)) {
    $presentationFragmentFound = $false
    foreach ($presentationSourcePath in @($previewPanelPath, $togglePatchPath)) {
        if (-not (Test-Path -LiteralPath $presentationSourcePath -PathType Leaf)) {
            continue
        }

        $presentationSourceText = Get-Content -LiteralPath $presentationSourcePath -Raw -Encoding UTF8
        if ($presentationSourceText.Contains($forbiddenPresentationFragment)) {
            $presentationFragmentFound = $true
            break
        }
    }

    if ($presentationFragmentFound) {
        Fail "Obsolete preview presentation reference remains: $forbiddenPresentationFragment"
    }
    else {
        Pass "Obsolete preview presentation reference is absent: $forbiddenPresentationFragment"
    }
}

$previewPanelText = Read-Text "Source/NiceInventoryTabAddOnPreview/PreviewPanelPatch.cs"

if ($null -ne $previewPanelText -and
    $previewPanelText -match '(?s)DrawRotationButton\(rotateLeftButton,\s*TexUI\.ArrowTexLeft.*?PreviewState\.RotateClockwise\(\)' -and
    $previewPanelText -match '(?s)TipRegion\(\s*rotateLeftButton,\s*"NITAP_RotateClockwise"\.Translate\(\)') {
    Pass "Left arrow maps to clockwise rotation and tooltip."
}
else {
    Fail "Left arrow does not map to clockwise rotation and tooltip."
}

if ($null -ne $previewPanelText -and
    $previewPanelText -match '(?s)DrawRotationButton\(rotateRightButton,\s*TexUI\.ArrowTexRight.*?PreviewState\.RotateCounterclockwise\(\)' -and
    $previewPanelText -match '(?s)TipRegion\(\s*rotateRightButton,\s*"NITAP_RotateCounterclockwise"\.Translate\(\)') {
    Pass "Right arrow maps to counterclockwise rotation and tooltip."
}
else {
    Fail "Right arrow does not map to counterclockwise rotation and tooltip."
}

foreach ($languageFile in @(
    "Languages/English/Keyed/NiceInventoryTabAddOnPreview.xml",
    "Languages/French/Keyed/NiceInventoryTabAddOnPreview.xml"
)) {
    $languagePath = Join-Path $RepositoryRoot $languageFile
    if (-not (Test-Path -LiteralPath $languagePath -PathType Leaf)) {
        continue
    }

    try {
        [xml]$languageXml = Get-Content -LiteralPath $languagePath -Raw -Encoding UTF8
        if ($null -ne $languageXml.LanguageData.NITAP_PreviewToggle -and
            $null -ne $languageXml.LanguageData.NITAP_RotateCounterclockwise -and
            $null -ne $languageXml.LanguageData.NITAP_RotateClockwise) {
            Pass "Preview translations are complete: $languageFile"
        }
        else {
            Fail "Preview translations are incomplete: $languageFile"
        }
    }
    catch {
        Fail "Invalid translation XML in ${languageFile}: $($_.Exception.Message)"
    }
}

if ($null -ne $about) {
    $packageIds = @($about.ModMetaData.modDependencies.li.packageId)
    foreach ($requiredPackage in @("brrainz.harmony", "Andromeda.NiceInventoryTab")) {
        if ($packageIds -contains $requiredPackage) {
            Pass "Dependency declared: $requiredPackage"
        }
        else {
            Fail "Missing dependency: $requiredPackage"
        }
    }
}

$workshopDescriptionText = Read-Text "docs/WORKSHOP_DESCRIPTION.md"
$frenchWorkshopHeading = "[h1]Fran$([char]0x00E7)ais[/h1]"
foreach ($fragment in @(
    "2009463077",
    "3609897594",
    "[h1]Nice Inventory Tab Add-on: Preview[/h1]",
    $frenchWorkshopHeading
)) {
    Assert-Contains -Text $workshopDescriptionText -Fragment $fragment -Description "Workshop description"
}

$workshopPublicationText = Read-Text "docs/WORKSHOP_PUBLICATION.md"
foreach ($fragment in @(
    "PublishedFileId.txt",
    "stage-workshop.cmd",
    "git merge --ff-only develop",
    "v1.0.0"
)) {
    Assert-Contains -Text $workshopPublicationText -Fragment $fragment -Description "Workshop publication procedure"
}

$optionalPublishedIdPath = Join-Path $RepositoryRoot "About/PublishedFileId.txt"
if (Test-Path -LiteralPath $optionalPublishedIdPath -PathType Leaf) {
    $optionalPublishedId = (Get-Content -LiteralPath $optionalPublishedIdPath -Raw -Encoding UTF8).Trim()
    if ($optionalPublishedId -match '^\d+$') {
        Pass "Optional Workshop ID is numeric: $optionalPublishedId."
    }
    else {
        Fail "About/PublishedFileId.txt must contain only the numeric Steam Workshop item ID."
    }
}
else {
    Pass "No placeholder PublishedFileId.txt exists before first Workshop upload."
}

if ($RequirePublicationReady) {
    $projectStateText = Read-Text "docs/PROJECT_STATE.md"
    $roadmapText = Read-Text "docs/ROADMAP.md"
    $testingCurrentText = Read-Text "docs/TESTING_CURRENT.md"
    $readmeText = Read-Text "README.md"

    if ($projectStateText.Contains('- Version: `' + $version + '`') -and
        $projectStateText -match '(?m)^- Status: validated and closed$') {
        Pass "Project state marks $version as validated and closed."
    }
    else {
        Fail "Project state is not publication-ready for $version."
    }

    if ($projectStateText.Contains('- Tag: `v' + $version + '`')) {
        Pass "Project state records tag v$version."
    }
    else {
        Fail "Project state does not record tag v$version."
    }

    if ($roadmapText.Contains("### $version -") -and
        $roadmapText.Contains("## Validated milestones")) {
        Pass "Roadmap records $version under validated milestones."
    }
    else {
        Fail "Roadmap does not record the current version as validated."
    }

    if ($testingCurrentText -match '(?m)^Status: validated locally after `r\d+`; milestone closed for publication\.$') {
        Pass "Current testing records a completed local validation."
    }
    else {
        Fail "Current testing does not record a completed local validation."
    }

    if ($readmeText.Contains("docs/images/workshop-main.png") -and
        $readmeText.Contains("docs/images/workshop-preview.png")) {
        Pass "README references both Workshop images."
    }
    else {
        Fail "README does not reference both Workshop images."
    }

    if ($version -notmatch '-dev$') {
        $publishedIdPath = Join-Path $RepositoryRoot "About/PublishedFileId.txt"
        if (Test-Path -LiteralPath $publishedIdPath -PathType Leaf) {
            $publishedId = (Get-Content -LiteralPath $publishedIdPath -Raw -Encoding UTF8).Trim()
            if ($publishedId -match '^\d+$') {
                Pass "Stable release records Workshop ID $publishedId."
            }
            else {
                Fail "About/PublishedFileId.txt does not contain a numeric Workshop ID."
            }

            if ($projectStateText.Contains($publishedId)) {
                Pass "Project state records the Workshop ID."
            }
            else {
                Fail "Project state does not record the Workshop ID."
            }

            $expectedWorkshopUrl = "https://steamcommunity.com/sharedfiles/filedetails/?id=$publishedId"
            if ($projectStateText.Contains($expectedWorkshopUrl)) {
                Pass "Project state Workshop URL matches the published ID."
            }
            else {
                Fail "Project state Workshop URL does not match About/PublishedFileId.txt."
            }

            $expectedSteamUrl = "steam://url/CommunityFilePage/$publishedId"
            $aboutSteamUrl = [string]$about.ModMetaData.steamWorkshopUrl
            if ($aboutSteamUrl -eq $expectedSteamUrl) {
                Pass "About metadata Workshop URL matches the published ID."
            }
            else {
                Fail "About metadata Workshop URL is '$aboutSteamUrl'; expected '$expectedSteamUrl'."
            }
        }
        else {
            Fail "Stable publication requires the real About/PublishedFileId.txt."
        }

        if ($projectStateText -match 'https://steamcommunity\.com/sharedfiles/filedetails/\?id=\d+') {
            Pass "Project state records the Workshop URL."
        }
        else {
            Fail "Project state does not record the Workshop URL."
        }
    }

    $obsoleteMarkers = @(
        "awaiting local validation",
        "ready for local build and validation",
        "release candidate `r1` prepared",
        "local Workshop validation required",
        "Required local validation",
        "Current implementation awaiting validation"
    )

    foreach ($marker in $obsoleteMarkers) {
        $found = $false
        foreach ($documentText in @($projectStateText, $roadmapText, $testingCurrentText)) {
            if ($null -ne $documentText -and
                $documentText.IndexOf($marker, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
                $found = $true
                break
            }
        }

        if ($found) {
            Fail "Publication documents still contain obsolete marker: $marker"
        }
        else {
            Pass "Publication documents omit obsolete marker: $marker"
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Consistency check failed with $($failures.Count) error(s)." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Consistency check passed." -ForegroundColor Green
