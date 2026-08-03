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
    "package-mod.cmd",
    "tools/package-mod.ps1",
    "docs/PACKAGING.md",
    "docs/PROJECT_STATE.md",
    "docs/ROADMAP.md",
    "docs/TESTING_CURRENT.md",
    "docs/TESTING.md",
    "docs/CHANGELOG.md"
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


$gitignorePath = Join-Path $RepositoryRoot ".gitignore"
if (Test-Path -LiteralPath $gitignorePath -PathType Leaf) {
    $gitignoreText = Get-Content -LiteralPath $gitignorePath -Raw -Encoding UTF8
    if ($gitignoreText -match '(?m)^dist/$') { Pass "Generated package directory is ignored." } else { Fail "Missing dist/ entry in .gitignore." }
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

$packageIds = @($about.ModMetaData.modDependencies.li.packageId)
foreach ($requiredPackage in @("brrainz.harmony", "Andromeda.NiceInventoryTab")) {
    if ($packageIds -contains $requiredPackage) { Pass "Dependency declared: $requiredPackage" } else { Fail "Missing dependency: $requiredPackage" }
}


if ($RequirePublicationReady) {
    $projectStateText = Get-Content -LiteralPath (Join-Path $RepositoryRoot "docs/PROJECT_STATE.md") -Raw -Encoding UTF8
    $roadmapText = Get-Content -LiteralPath (Join-Path $RepositoryRoot "docs/ROADMAP.md") -Raw -Encoding UTF8
    $testingCurrentText = Get-Content -LiteralPath (Join-Path $RepositoryRoot "docs/TESTING_CURRENT.md") -Raw -Encoding UTF8

    if ($projectStateText -match '(?m)^- Status: validated and closed$') {
        Pass "Project state marks the milestone as validated and closed."
    }
    else {
        Fail "Project state is not publication-ready."
    }

    if ($projectStateText.Contains('Tag: `v' + $version + '`')) {
        Pass "Project state records tag v$version."
    }
    else {
        Fail "Project state does not record tag v$version."
    }

    if ($roadmapText -match [regex]::Escape("### $version - Establish project foundation") -and
        $roadmapText.Contains('## Validated milestones')) {
        Pass "Roadmap records the milestone under validated milestones."
    }
    else {
        Fail "Roadmap does not record the current milestone as validated."
    }

    if ($testingCurrentText -match '(?m)^Status: validated locally after `r3`; milestone closed for publication\.$') {
        Pass "Current testing records the completed local validation."
    }
    else {
        Fail "Current testing does not record a completed validation."
    }

    $obsoleteMarkers = @(
        'awaiting local validation',
        'ready for local build and validation',
        'packaging correction awaiting local retest'
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
