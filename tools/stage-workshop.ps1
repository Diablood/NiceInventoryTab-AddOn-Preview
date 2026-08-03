[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [string]$ModsDirectory = "D:\SteamLibrary\steamapps\common\RimWorld\Mods",
    [string]$RimWorldManagedDir,
    [switch]$SkipBuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Join-Path $PSScriptRoot ".."
}
else {
    $RepositoryRoot = $RepositoryRoot.Trim().Trim('"')
}

$RepositoryRoot = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$ModsDirectory = [IO.Path]::GetFullPath($ModsDirectory)

$packageScript = Join-Path $RepositoryRoot "tools/package-mod.ps1"
$aboutPath = Join-Path $RepositoryRoot "About/About.xml"
$repositoryPublishedIdPath = Join-Path $RepositoryRoot "About/PublishedFileId.txt"
$packageFolderName = "NiceInventoryTab-AddOn-Preview"
$targetModRoot = Join-Path $ModsDirectory $packageFolderName
$targetPublishedIdPath = Join-Path $targetModRoot "About/PublishedFileId.txt"
$outputDirectory = Join-Path $RepositoryRoot "dist"
$temporaryRoot = Join-Path $outputDirectory ".workshop-extract"

if (-not (Test-Path -LiteralPath $packageScript -PathType Leaf)) {
    throw "Package generator not found: $packageScript"
}

if (-not (Test-Path -LiteralPath $aboutPath -PathType Leaf)) {
    throw "About/About.xml not found: $aboutPath"
}

if ([IO.Path]::GetFullPath($targetModRoot).TrimEnd('\') -eq $RepositoryRoot.TrimEnd('\')) {
    throw "Workshop staging target cannot be the repository itself."
}

[xml]$about = Get-Content -LiteralPath $aboutPath -Raw -Encoding UTF8
$version = [string]$about.ModMetaData.modVersion
$archivePath = Join-Path $outputDirectory "$packageFolderName-$version.zip"

$repositoryPublishedId = $null
if (Test-Path -LiteralPath $repositoryPublishedIdPath -PathType Leaf) {
    $repositoryPublishedId = (Get-Content -LiteralPath $repositoryPublishedIdPath -Raw -Encoding UTF8).Trim()
}

$stagedPublishedId = $null
if (Test-Path -LiteralPath $targetPublishedIdPath -PathType Leaf) {
    $stagedPublishedId = (Get-Content -LiteralPath $targetPublishedIdPath -Raw -Encoding UTF8).Trim()
}

foreach ($publishedIdCheck in @(
    @{ Name = "repository"; Value = $repositoryPublishedId },
    @{ Name = "staged mod"; Value = $stagedPublishedId }
)) {
    if (-not [string]::IsNullOrWhiteSpace($publishedIdCheck.Value) -and
        $publishedIdCheck.Value -notmatch '^\d+$') {
        throw "The $($publishedIdCheck.Name) PublishedFileId.txt is not a numeric Steam Workshop item ID."
    }
}

if (-not [string]::IsNullOrWhiteSpace($repositoryPublishedId) -and
    -not [string]::IsNullOrWhiteSpace($stagedPublishedId) -and
    $repositoryPublishedId -ne $stagedPublishedId) {
    throw "Workshop ID mismatch. Repository uses '$repositoryPublishedId' but staged mod uses '$stagedPublishedId'."
}

$packageArguments = @{
    RepositoryRoot = $RepositoryRoot
    OutputDirectory = $outputDirectory
}

if (-not [string]::IsNullOrWhiteSpace($RimWorldManagedDir)) {
    $packageArguments.RimWorldManagedDir = $RimWorldManagedDir
}

if ($SkipBuild) {
    $packageArguments.SkipBuild = $true
}

& $packageScript @packageArguments

if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
    throw "Expected package archive not found: $archivePath"
}

New-Item -ItemType Directory -Path $ModsDirectory -Force | Out-Null
Remove-Item -LiteralPath $temporaryRoot -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $temporaryRoot -Force | Out-Null

try {
    Expand-Archive -LiteralPath $archivePath -DestinationPath $temporaryRoot -Force
    $expandedModRoot = Join-Path $temporaryRoot $packageFolderName

    if (-not (Test-Path -LiteralPath $expandedModRoot -PathType Container)) {
        throw "Expanded package root not found: $expandedModRoot"
    }

    Remove-Item -LiteralPath $targetModRoot -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Path $targetModRoot -Force | Out-Null

    Get-ChildItem -LiteralPath $expandedModRoot -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $targetModRoot -Recurse -Force
    }

    if ([string]::IsNullOrWhiteSpace($repositoryPublishedId) -and
        -not [string]::IsNullOrWhiteSpace($stagedPublishedId)) {
        New-Item -ItemType Directory -Path (Split-Path -Parent $targetPublishedIdPath) -Force | Out-Null
        Set-Content -LiteralPath $targetPublishedIdPath -Value $stagedPublishedId -Encoding UTF8
    }

    $finalPublishedId = $null
    if (Test-Path -LiteralPath $targetPublishedIdPath -PathType Leaf) {
        $finalPublishedId = (Get-Content -LiteralPath $targetPublishedIdPath -Raw -Encoding UTF8).Trim()
    }

    Write-Host ""
    Write-Host "Clean Workshop mod staged:" -ForegroundColor Green
    Write-Host $targetModRoot
    Write-Host "Version: $version"

    if ([string]::IsNullOrWhiteSpace($finalPublishedId)) {
        Write-Host ""
        Write-Host "No PublishedFileId.txt exists yet." -ForegroundColor Yellow
        Write-Host "After the first successful Steam upload, copy the generated file back into the repository."
    }
    elseif ([string]::IsNullOrWhiteSpace($repositoryPublishedId)) {
        Write-Host ""
        Write-Host "Existing staged Workshop ID preserved: $finalPublishedId" -ForegroundColor Yellow
        Write-Host "Copy About/PublishedFileId.txt back into the repository before final publication."
    }
    else {
        Write-Host "Workshop ID preserved: $finalPublishedId"
    }
}
finally {
    Remove-Item -LiteralPath $temporaryRoot -Recurse -Force -ErrorAction SilentlyContinue
}
