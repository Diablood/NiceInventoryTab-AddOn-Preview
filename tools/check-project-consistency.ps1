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

function Pass([string]$Message) { Write-Host "[PASS] $Message" -ForegroundColor Green }
function Fail([string]$Message) { [void]$failures.Add($Message); Write-Host "[FAIL] $Message" -ForegroundColor Red }

Write-Host "Nice Inventory Tab Add-on: Preview consistency check"
Write-Host "Repository: $RepositoryRoot"
Write-Host ""

$markdownFiles = @()
$readme = Join-Path $RepositoryRoot "README.md"
if (Test-Path -LiteralPath $readme) { $markdownFiles += Get-Item -LiteralPath $readme }
$docs = Join-Path $RepositoryRoot "docs"
if (Test-Path -LiteralPath $docs) { $markdownFiles += Get-ChildItem -LiteralPath $docs -Filter "*.md" -File -Recurse }

$tabFiles = @()
foreach ($file in $markdownFiles) {
    if ((Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8).Contains("`t")) {
        $tabFiles += $file.FullName
    }
}
if ($tabFiles.Count -eq 0) { Pass "Markdown files contain no literal tab characters." } else { Fail "Literal tabs found: $($tabFiles -join ', ')" }

$required = @(
    "About/About.xml",
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
    "tools/package-mod.ps1",
    "docs/PACKAGING.md",
    "docs/PROJECT_STATE.md",
    "docs/ROADMAP.md",
    "docs/TESTING_CURRENT.md",
    "docs/TESTING.md",
    "docs/CHANGELOG.md",
    "docs/images/workshop-preview.png"
)
foreach ($relative in $required) {
    if (Test-Path -LiteralPath (Join-Path $RepositoryRoot $relative) -PathType Leaf) { Pass "Required file exists: $relative" } else { Fail "Missing required file: $relative" }
}

[xml]$about = Get-Content -LiteralPath (Join-Path $RepositoryRoot "About/About.xml") -Raw -Encoding UTF8
$version = [string]$about.ModMetaData.modVersion
if ($version -match '^\d+\.\d+\.\d+-dev$') { Pass "About mod version is '$version'." } else { Fail "Invalid mod version '$version'." }
if (-not [string]::IsNullOrWhiteSpace($ExpectedVersion)) {
    if ($version -eq $ExpectedVersion) { Pass "Requested milestone version matches '$ExpectedVersion'." } else { Fail "Requested version is '$ExpectedVersion' but About uses '$version'." }
}

$numeric = $version -replace '-dev$', '.0'
[xml]$project = Get-Content -LiteralPath (Join-Path $RepositoryRoot "Source/NiceInventoryTabAddOnPreview/NiceInventoryTabAddOnPreview.csproj") -Raw -Encoding UTF8
$group = @($project.Project.PropertyGroup) | Where-Object { $_.Version } | Select-Object -First 1
foreach ($name in @("Version", "AssemblyVersion", "FileVersion")) {
    $value = [string]$group.$name
    if ($value -eq $numeric) { Pass "$name matches '$numeric'." } else { Fail "$name is '$value'; expected '$numeric'." }
}

$referenceNames = @($project.Project.ItemGroup.Reference | ForEach-Object { [string]$_.Include })
if ($referenceNames -contains "UnityEngine.TextRenderingModule") {
    Pass "UnityEngine.TextRenderingModule reference is declared."
}
else {
    Fail "Missing UnityEngine.TextRenderingModule project reference."
}


$gitignorePath = Join-Path $RepositoryRoot ".gitignore"
if (Test-Path -LiteralPath $gitignorePath -PathType Leaf) {
    $gitignoreEntries = @(Get-Content -LiteralPath $gitignorePath -Encoding UTF8 | ForEach-Object { $_.Trim() })
    if ($gitignoreEntries -contains 'dist/') { Pass "Generated package directory is ignored." } else { Fail "Missing dist/ entry in .gitignore." }
}
else {
    Fail "Missing required file: .gitignore"
}

$packageWrapperPath = Join-Path $RepositoryRoot "package-mod.cmd"
if (Test-Path -LiteralPath $packageWrapperPath -PathType Leaf) {
    $packageWrapperText = Get-Content -LiteralPath $packageWrapperPath -Raw -Encoding UTF8
    if ($packageWrapperText.Contains('-RepositoryRoot "%~dp0."')) {
        Pass "Package wrapper passes a quote-safe repository path."
    }
    else {
        Fail 'Package wrapper must pass -RepositoryRoot "%~dp0." to avoid a trailing quote on Windows.'
    }
}

$packageScriptPath = Join-Path $RepositoryRoot "tools/package-mod.ps1"
if (Test-Path -LiteralPath $packageScriptPath -PathType Leaf) {
    $packageScriptText = Get-Content -LiteralPath $packageScriptPath -Raw -Encoding UTF8
    foreach ($expectedFragment in @(
        'NiceInventoryTab-AddOn-Preview',
        'NiceInventoryTabAddOnPreview.dll',
        'CreateFromDirectory',
        'OpenRead'
    )) {
        if ($packageScriptText.Contains($expectedFragment)) { Pass "Package generator contains '$expectedFragment'." } else { Fail "Package generator is missing '$expectedFragment'." }
    }
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

$previewPanelText = $null
if (Test-Path -LiteralPath $previewPanelPath -PathType Leaf) {
    $previewPanelText = Get-Content -LiteralPath $previewPanelPath -Raw -Encoding UTF8
}

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

$packageIds = @($about.ModMetaData.modDependencies.li.packageId)
foreach ($requiredPackage in @("brrainz.harmony", "Andromeda.NiceInventoryTab")) {
    if ($packageIds -contains $requiredPackage) { Pass "Dependency declared: $requiredPackage" } else { Fail "Missing dependency: $requiredPackage" }
}


if ($RequirePublicationReady) {
    $projectStateText = Get-Content -LiteralPath (Join-Path $RepositoryRoot "docs/PROJECT_STATE.md") -Raw -Encoding UTF8
    $roadmapText = Get-Content -LiteralPath (Join-Path $RepositoryRoot "docs/ROADMAP.md") -Raw -Encoding UTF8
    $testingCurrentText = Get-Content -LiteralPath (Join-Path $RepositoryRoot "docs/TESTING_CURRENT.md") -Raw -Encoding UTF8
    $readmeText = Get-Content -LiteralPath (Join-Path $RepositoryRoot "README.md") -Raw -Encoding UTF8

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

    if ($projectStateText.Contains('- Latest local validation revision: `r8`')) {
        Pass "Project state records final local revision r8."
    }
    else {
        Fail "Project state does not record final local revision r8."
    }

    if ($roadmapText.Contains('### ' + $version + ' - Add rotatable pawn preview prototype') -and
        $roadmapText.Contains('## Validated milestones')) {
        Pass "Roadmap records the milestone under validated milestones."
    }
    else {
        Fail "Roadmap does not record the current milestone as validated."
    }

    if ($testingCurrentText -match '(?m)^Status: validated locally after `r8`; milestone closed for publication\.$') {
        Pass "Current testing records the completed r8 validation."
    }
    else {
        Fail "Current testing does not record the completed r8 validation."
    }

    if ($readmeText.Contains('docs/images/workshop-preview.png')) {
        Pass "README references the validated Workshop preview image."
    }
    else {
        Fail "README does not reference docs/images/workshop-preview.png."
    }

    $workshopPreviewPath = Join-Path $RepositoryRoot "docs/images/workshop-preview.png"
    if (Test-Path -LiteralPath $workshopPreviewPath -PathType Leaf) {
        Pass "Validated Workshop preview image exists."
    }
    else {
        Fail "Missing validated Workshop preview image."
    }

    $obsoleteMarkers = @(
        'awaiting local validation',
        'ready for local build and validation',
        'packaging correction awaiting local retest',
        'Status: `r8` prepared',
        'Current implementation awaiting validation',
        'Required validation'
    )

    foreach ($marker in $obsoleteMarkers) {
        $found = $false
        foreach ($documentText in @($projectStateText, $roadmapText, $testingCurrentText)) {
            if ($documentText.IndexOf($marker, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
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
