<#
.SYNOPSIS
    Sync AlexAgent plugin from Master Alex source

.DESCRIPTION
    Copies the latest plugin bundle from platforms/agent-plugin/plugin/
    in the Master Alex workspace to this repository.

.PARAMETER MasterPath
    Path to the Master Alex workspace. Defaults to C:\Development\AlexMaster\Alex_Plug_In

.EXAMPLE
    .\sync-from-master.ps1
    .\sync-from-master.ps1 -MasterPath "D:\MyAlex"
#>

param(
    [string]$MasterPath = "C:\Development\AlexMaster\Alex_Plug_In"
)

$ErrorActionPreference = "Stop"
$SourcePlugin = Join-Path $MasterPath "platforms\agent-plugin\plugin"
$DestPlugin = Join-Path $PSScriptRoot "plugin"

Write-Host ""
Write-Host "Syncing AlexAgent from Master Alex" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Validate source
if (-not (Test-Path $SourcePlugin)) {
    Write-Host "ERROR: Source not found at $SourcePlugin" -ForegroundColor Red
    exit 1
}

# Count source files
$sourceFiles = Get-ChildItem $SourcePlugin -Recurse -File
Write-Host "Source: $SourcePlugin" -ForegroundColor DarkGray
Write-Host "Files:  $($sourceFiles.Count)" -ForegroundColor DarkGray
Write-Host ""

# Remove old plugin directory (except .git)
if (Test-Path $DestPlugin) {
    Write-Host "Removing old plugin bundle..." -ForegroundColor Yellow
    Remove-Item $DestPlugin -Recurse -Force
}

# Copy fresh plugin bundle
Write-Host "Copying plugin bundle..." -ForegroundColor Yellow
Copy-Item $SourcePlugin $DestPlugin -Recurse

# Count destination files
$destFiles = Get-ChildItem $DestPlugin -Recurse -File
Write-Host "  Copied $($destFiles.Count) files" -ForegroundColor Green
Write-Host ""

# Show git diff summary
Write-Host "Changes:" -ForegroundColor Yellow
Push-Location $PSScriptRoot
$status = git status --short
if ($status) {
    $added = ($status | Where-Object { $_ -match "^\?\?" }).Count
    $modified = ($status | Where-Object { $_ -match "^ M" }).Count
    $deleted = ($status | Where-Object { $_ -match "^ D" }).Count
    Write-Host "  Added:    $added" -ForegroundColor Green
    Write-Host "  Modified: $modified" -ForegroundColor Yellow
    Write-Host "  Deleted:  $deleted" -ForegroundColor Red
    Write-Host ""
    Write-Host "Run 'git add -A && git commit -m ""Sync from Master vX.Y.Z""' to commit." -ForegroundColor DarkGray
} else {
    Write-Host "  No changes — already in sync." -ForegroundColor Green
}
Pop-Location
Write-Host ""
