#Requires -Version 5.1
<#
.SYNOPSIS
    Configure VS Code settings for the Alex Agent Plugin.
.DESCRIPTION
    Run this from the cloned AlexAgent folder to register the plugin with VS Code.
    Does NOT clone — use VS Code's Git: Clone first.
.EXAMPLE
    .\setup.ps1
#>

$ErrorActionPreference = "Stop"

$PluginPath = Join-Path $PSScriptRoot "plugin"

if (-not (Test-Path $PluginPath)) {
    Write-Host "✗ plugin/ folder not found. Run this from the AlexAgent repo root." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🧠 Alex Agent Plugin Setup" -ForegroundColor Cyan
Write-Host ""

# VS Code settings path
$SettingsPath = Join-Path $env:APPDATA "Code\User\settings.json"

if (Test-Path $SettingsPath) {
    $settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json -AsHashtable
}
else {
    $settings = @{}
    $settingsDir = Split-Path $SettingsPath -Parent
    if (-not (Test-Path $settingsDir)) {
        New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
    }
}

$normalizedPath = $PluginPath.Replace("\", "/")
$modified = $false

if (-not $settings.ContainsKey("chat.agent.enabled") -or $settings["chat.agent.enabled"] -ne $true) {
    $settings["chat.agent.enabled"] = $true
    $modified = $true
}

if (-not $settings.ContainsKey("chat.plugins.enabled") -or $settings["chat.plugins.enabled"] -ne $true) {
    $settings["chat.plugins.enabled"] = $true
    $modified = $true
}

if (-not $settings.ContainsKey("chat.plugins.paths")) {
    $settings["chat.plugins.paths"] = @{}
}

if ($settings["chat.plugins.paths"] -is [hashtable]) {
    if (-not $settings["chat.plugins.paths"].ContainsKey($normalizedPath)) {
        $settings["chat.plugins.paths"][$normalizedPath] = $true
        $modified = $true
    }
}
else {
    $settings["chat.plugins.paths"] = @{ $normalizedPath = $true }
    $modified = $true
}

if ($modified) {
    $settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsPath -Encoding UTF8
    Write-Host "✓ VS Code settings updated" -ForegroundColor Green
}
else {
    Write-Host "✓ VS Code settings already configured" -ForegroundColor Green
}

Write-Host "  Plugin path: $normalizedPath" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Next: Ctrl+Shift+P → 'Reload Window', then open Copilot Chat." -ForegroundColor Yellow
Write-Host ""
