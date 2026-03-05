#Requires -Version 5.1
<#
.SYNOPSIS
    Install Alex Agent Plugin for VS Code

.DESCRIPTION
    Downloads and configures the Alex Agent Plugin, enabling AI cognitive 
    architecture features in VS Code's Copilot Chat.

.EXAMPLE
    # Run directly from web
    irm https://raw.githubusercontent.com/fabioc-aloha/AlexAgent/main/install.ps1 | iex

.EXAMPLE
    # Run locally
    .\install.ps1

.NOTES
    Requires: VS Code 1.110+, GitHub Copilot, Git
#>

$ErrorActionPreference = "Stop"

# Configuration
$RepoUrl = "https://github.com/fabioc-aloha/AlexAgent.git"
$InstallPath = Join-Path $env:USERPROFILE ".alex-agent"
$PluginPath = Join-Path $InstallPath "plugin"

Write-Host ""
Write-Host "🧠 Alex Agent Plugin Installer" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Git
try {
    $null = Get-Command git -ErrorAction Stop
    Write-Host "  ✓ Git found" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Git not found. Install from https://git-scm.com/" -ForegroundColor Red
    exit 1
}

# Check VS Code
$vscodePaths = @(
    (Get-Command code -ErrorAction SilentlyContinue).Source,
    "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
    "$env:ProgramFiles\Microsoft VS Code\Code.exe"
) | Where-Object { $_ -and (Test-Path $_) }

if ($vscodePaths) {
    Write-Host "  ✓ VS Code found" -ForegroundColor Green
} else {
    Write-Host "  ⚠ VS Code not found in PATH (install may still work)" -ForegroundColor Yellow
}

# Check Node.js (optional, for MCP tools)
try {
    $null = Get-Command node -ErrorAction Stop
    Write-Host "  ✓ Node.js found (MCP tools will work)" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Node.js not found (MCP tools won't work, but plugin will)" -ForegroundColor Yellow
}

Write-Host ""

# Clone or update repository
if (Test-Path $InstallPath) {
    Write-Host "Updating existing installation..." -ForegroundColor Yellow
    Push-Location $InstallPath
    try {
        git pull --quiet
        Write-Host "  ✓ Updated to latest version" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Update failed, continuing with existing version" -ForegroundColor Yellow
    }
    Pop-Location
} else {
    Write-Host "Cloning Alex Agent Plugin..." -ForegroundColor Yellow
    git clone --quiet $RepoUrl $InstallPath
    Write-Host "  ✓ Cloned to $InstallPath" -ForegroundColor Green
}

Write-Host ""

# Get VS Code settings path
$SettingsPath = Join-Path $env:APPDATA "Code\User\settings.json"

# Configure VS Code settings
Write-Host "Configuring VS Code..." -ForegroundColor Yellow

if (Test-Path $SettingsPath) {
    $settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json -AsHashtable
} else {
    $settings = @{}
    # Create directory if needed
    $settingsDir = Split-Path $SettingsPath -Parent
    if (-not (Test-Path $settingsDir)) {
        New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
    }
}

# Ensure required settings
$modified = $false

# Enable agent mode
if (-not $settings.ContainsKey("chat.agent.enabled") -or $settings["chat.agent.enabled"] -ne $true) {
    $settings["chat.agent.enabled"] = $true
    $modified = $true
}

# Enable plugins
if (-not $settings.ContainsKey("chat.plugins.enabled") -or $settings["chat.plugins.enabled"] -ne $true) {
    $settings["chat.plugins.enabled"] = $true
    $modified = $true
}

# Add plugin path
$normalizedPath = $PluginPath.Replace("\", "/")
if (-not $settings.ContainsKey("chat.plugins.paths")) {
    $settings["chat.plugins.paths"] = @{}
}

if ($settings["chat.plugins.paths"] -is [hashtable]) {
    if (-not $settings["chat.plugins.paths"].ContainsKey($normalizedPath)) {
        $settings["chat.plugins.paths"][$normalizedPath] = $true
        $modified = $true
    }
} else {
    # Convert to hashtable if it's a different type
    $settings["chat.plugins.paths"] = @{ $normalizedPath = $true }
    $modified = $true
}

if ($modified) {
    $settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsPath -Encoding UTF8
    Write-Host "  ✓ VS Code settings updated" -ForegroundColor Green
} else {
    Write-Host "  ✓ VS Code settings already configured" -ForegroundColor Green
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "✓ Installation complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart VS Code (or Ctrl+Shift+P → 'Reload Window')"
Write-Host "  2. Open Copilot Chat (Ctrl+Alt+I)"
Write-Host "  3. Say 'Who are you?' to meet Alex"
Write-Host ""
Write-Host "Plugin installed at: $PluginPath" -ForegroundColor DarkGray
Write-Host ""

# Offer to open VS Code
$response = Read-Host "Open VS Code now? (Y/n)"
if ($response -ne "n" -and $response -ne "N") {
    if ($vscodePaths) {
        Start-Process "code"
    } else {
        Write-Host "Could not find VS Code. Please open it manually." -ForegroundColor Yellow
    }
}
