[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [string]$OutputDirectory,
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

if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $RepositoryRoot "dist"
}
elseif (-not [IO.Path]::IsPathRooted($OutputDirectory)) {
    $OutputDirectory = Join-Path $RepositoryRoot $OutputDirectory
}

$OutputDirectory = [IO.Path]::GetFullPath($OutputDirectory)
$aboutPath = Join-Path $RepositoryRoot "About/About.xml"
$previewPath = Join-Path $RepositoryRoot "About/Preview.png"
$modIconPath = Join-Path $RepositoryRoot "About/ModIcon.png"
$loadFoldersPath = Join-Path $RepositoryRoot "LoadFolders.xml"
$assemblyPath = Join-Path $RepositoryRoot "1.6/Assemblies/NiceInventoryTabAddOnPreview.dll"

function Assert-WorkshopPreview {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Required Workshop preview not found: $Path"
    }

    $previewInfo = Get-Item -LiteralPath $Path
    if ($previewInfo.Length -ge 1MB) {
        throw "About/Preview.png must remain below 1 MB; current size is $($previewInfo.Length) bytes."
    }

    Add-Type -AssemblyName System.Drawing
    $image = [System.Drawing.Image]::FromFile($Path)
    try {
        $validSize =
            ($image.Width -eq 640 -and $image.Height -eq 360) -or
            ($image.Width -eq 1280 -and $image.Height -eq 720)

        if (-not $validSize) {
            throw "About/Preview.png must be 640x360 or 1280x720; current size is $($image.Width)x$($image.Height)."
        }
    }
    finally {
        $image.Dispose()
    }
}

foreach ($requiredPath in @($aboutPath, $previewPath, $modIconPath, $loadFoldersPath)) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "Required runtime file not found: $requiredPath"
    }
}

Assert-WorkshopPreview -Path $previewPath


$publishedFileIdPath = Join-Path $RepositoryRoot "About/PublishedFileId.txt"
if (Test-Path -LiteralPath $publishedFileIdPath -PathType Leaf) {
    $publishedFileId = (Get-Content -LiteralPath $publishedFileIdPath -Raw -Encoding UTF8).Trim()
    if ($publishedFileId -notmatch '^\d+$') {
        throw "About/PublishedFileId.txt must contain only the numeric Steam Workshop item ID."
    }
}

[xml]$about = Get-Content -LiteralPath $aboutPath -Raw -Encoding UTF8
$version = [string]$about.ModMetaData.modVersion
if ($version -notmatch '^\d+\.\d+\.\d+(-dev)?$') {
    throw "Unsupported mod version in About/About.xml: '$version'"
}

if (-not $SkipBuild) {
    $buildCommand = Join-Path $RepositoryRoot "build.cmd"
    if (-not (Test-Path -LiteralPath $buildCommand -PathType Leaf)) {
        throw "Build command not found: $buildCommand"
    }

    Write-Host "Building Release assembly..."
    if ([string]::IsNullOrWhiteSpace($RimWorldManagedDir)) {
        & $buildCommand
    }
    else {
        & $buildCommand $RimWorldManagedDir
    }

    if ($LASTEXITCODE -ne 0) {
        throw "Release build failed with exit code $LASTEXITCODE."
    }
}

if (-not (Test-Path -LiteralPath $assemblyPath -PathType Leaf)) {
    throw "Compiled assembly not found: $assemblyPath"
}

$packageFolderName = "NiceInventoryTab-AddOn-Preview"
$archiveName = "$packageFolderName-$version.zip"
$archivePath = Join-Path $OutputDirectory $archiveName
$stagingRoot = Join-Path $OutputDirectory ".package-staging"
$stagedModRoot = Join-Path $stagingRoot $packageFolderName

$runtimeDirectories = @(
    "About",
    "1.6",
    "Common",
    "Defs",
    "Languages",
    "Patches",
    "Sounds",
    "Textures"
)

$forbiddenTopLevelNames = @(
    ".git",
    ".github",
    ".idea",
    ".vs",
    ".vscode",
    "docs",
    "Source",
    "tools",
    "dist",
    "bin",
    "obj"
)

$forbiddenFilePatterns = @(
    "*.cs",
    "*.csproj",
    "*.sln",
    "*.pdb",
    "*.mdb",
    "*.user",
    "*.suo",
    "*.zip",
    "*.patch",
    ".gitignore",
    ".gitkeep"
)

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $archivePath -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $stagedModRoot -Force | Out-Null

try {
    foreach ($relativeDirectory in $runtimeDirectories) {
        $sourceDirectory = Join-Path $RepositoryRoot $relativeDirectory
        if (Test-Path -LiteralPath $sourceDirectory -PathType Container) {
            Copy-Item -LiteralPath $sourceDirectory -Destination $stagedModRoot -Recurse -Force
        }
    }

    Copy-Item -LiteralPath $loadFoldersPath -Destination (Join-Path $stagedModRoot "LoadFolders.xml") -Force

    foreach ($pattern in $forbiddenFilePatterns) {
        Get-ChildItem -LiteralPath $stagedModRoot -Recurse -Force -File -Filter $pattern -ErrorAction SilentlyContinue |
            Remove-Item -Force
    }

    $requiredStagedFiles = @(
        (Join-Path $stagedModRoot "About/About.xml"),
        (Join-Path $stagedModRoot "About/Preview.png"),
        (Join-Path $stagedModRoot "About/ModIcon.png"),
        (Join-Path $stagedModRoot "LoadFolders.xml"),
        (Join-Path $stagedModRoot "1.6/Assemblies/NiceInventoryTabAddOnPreview.dll")
    )

    foreach ($requiredStagedFile in $requiredStagedFiles) {
        if (-not (Test-Path -LiteralPath $requiredStagedFile -PathType Leaf)) {
            throw "Required packaged file not found: $requiredStagedFile"
        }
    }

    Assert-WorkshopPreview -Path (Join-Path $stagedModRoot "About/Preview.png")

    foreach ($forbiddenName in $forbiddenTopLevelNames) {
        if (Test-Path -LiteralPath (Join-Path $stagedModRoot $forbiddenName)) {
            throw "Forbidden development path entered the package: $forbiddenName"
        }
    }

    $forbiddenFiles = @()
    foreach ($pattern in $forbiddenFilePatterns) {
        $forbiddenFiles += Get-ChildItem -LiteralPath $stagedModRoot -Recurse -Force -File -Filter $pattern -ErrorAction SilentlyContinue
    }

    if ($forbiddenFiles.Count -gt 0) {
        throw "Forbidden development files entered the package: $($forbiddenFiles.FullName -join ', ')"
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [IO.Compression.ZipFile]::CreateFromDirectory(
        $stagingRoot,
        $archivePath,
        [IO.Compression.CompressionLevel]::Optimal,
        $false
    )

    $archive = [IO.Compression.ZipFile]::OpenRead($archivePath)
    try {
        $entries = @($archive.Entries | ForEach-Object { $_.FullName.Replace('\', '/') })
        $requiredEntries = @(
            "$packageFolderName/About/About.xml",
            "$packageFolderName/About/Preview.png",
            "$packageFolderName/About/ModIcon.png",
            "$packageFolderName/LoadFolders.xml",
            "$packageFolderName/1.6/Assemblies/NiceInventoryTabAddOnPreview.dll"
        )

        foreach ($requiredEntry in $requiredEntries) {
            if ($entries -notcontains $requiredEntry) {
                throw "Required ZIP entry not found: $requiredEntry"
            }
        }

        $invalidEntries = @($entries | Where-Object {
            $_ -notlike "$packageFolderName/*" -or
            $_ -match '(^|/)(Source|docs|tools|dist|bin|obj|\.git|\.github|\.idea|\.vs|\.vscode)(/|$)' -or
            $_ -match '\.(cs|csproj|sln|pdb|mdb|user|suo|zip|patch)$' -or
            $_ -match '(^|/)(\.gitignore|\.gitkeep)$'
        })

        if ($invalidEntries.Count -gt 0) {
            throw "Invalid ZIP entries found: $($invalidEntries -join ', ')"
        }
    }
    finally {
        $archive.Dispose()
    }

    $archiveInfo = Get-Item -LiteralPath $archivePath
    Write-Host ""
    Write-Host "Clean RimWorld package created:" -ForegroundColor Green
    Write-Host $archiveInfo.FullName
    Write-Host ("Size: {0:N0} bytes" -f $archiveInfo.Length)
}
finally {
    Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
}
