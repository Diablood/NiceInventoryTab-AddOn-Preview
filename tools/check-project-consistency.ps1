[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [string]$ExpectedVersion
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

$packageIds = @($about.ModMetaData.modDependencies.li.packageId)
foreach ($requiredPackage in @("brrainz.harmony", "Andromeda.NiceInventoryTab")) {
    if ($packageIds -contains $requiredPackage) { Pass "Dependency declared: $requiredPackage" } else { Fail "Missing dependency: $requiredPackage" }
}

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Consistency check failed with $($failures.Count) error(s)." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Consistency check passed." -ForegroundColor Green
