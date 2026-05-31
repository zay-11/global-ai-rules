# install.ps1 v2.0 -- Installateur systeme avec rollback et validation
param([switch]$Uninstall)
$ErrorActionPreference = "Stop"

$userProfile   = $env:USERPROFILE
$localBin      = Join-Path $userProfile ".local\bin"
$claudeHooks   = Join-Path $userProfile ".claude\hooks"
$settingsPath  = Join-Path $userProfile ".claude\settings.json"
$installDir    = Join-Path $localBin "global-ai-rules"
$scriptDir     = Split-Path -Parent $MyInvocation.MyCommand.Definition

if ($Uninstall) {
    & (Join-Path $scriptDir "uninstall.ps1")
    return
}

Write-Host ""
Write-Host "================================================================="
Write-Host "  GLOBAL AI RULES v2.0 -- INSTALLATION"
Write-Host "================================================================="
Write-Host ""

# --- Pre-flight checks -------------------------------------------------------
Write-Host "[CHECK] Validating environment..."

try {
    $nodeVersion = (node --version 2>$null)
    Write-Host "  [OK]  Node.js found: $nodeVersion"
} catch {
    Write-Warning "  Node.js not found. The session hook requires Node.js."
    Write-Warning "  Install from: https://nodejs.org (LTS recommended)"
}

Write-Host ""

# --- Create directories ------------------------------------------------------
Write-Host "[1/4] Creating directories..."
foreach ($dir in @($localBin, $claudeHooks, $installDir)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force > $null
        Write-Host "  [OK]  Created: $dir"
    } else {
        Write-Host "  [OK]  Exists:  $dir"
    }
}
Write-Host ""

# --- Deploy files ------------------------------------------------------------
Write-Host "[2/4] Deploying files..."
$filesToCopy = @(
    @{ Src = "CLAUDE.md";               Dst = Join-Path $installDir "CLAUDE.md" },
    @{ Src = "archetypes.json";         Dst = Join-Path $installDir "archetypes.json" },
    @{ Src = "global-orchestrator.mjs"; Dst = Join-Path $claudeHooks "global-orchestrator.mjs" },
    @{ Src = "setup-karpathy.ps1";      Dst = Join-Path $localBin "setup-karpathy.ps1" },
    @{ Src = "update.ps1";              Dst = Join-Path $localBin "global-ai-rules-update.ps1" }
)

foreach ($f in $filesToCopy) {
    $src = Join-Path $scriptDir $f.Src
    if (Test-Path $src) {
        Copy-Item $src $f.Dst -Force
        Write-Host "  [OK]  $($f.Src) -> $($f.Dst)"
    } else {
        Write-Warning "  [SKIP] Source not found: $src"
    }
}
Write-Host ""

# --- Register Claude Code hook -----------------------------------------------
Write-Host "[3/4] Configuring Claude Code session hook..."
$hookCmd = "node `"$claudeHooks\global-orchestrator.mjs`""

$backupPath = $null
if (Test-Path $settingsPath) {
    $backupPath = "$settingsPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $settingsPath $backupPath
    Write-Host "  [OK]  Backup created: $backupPath"
}

try {
    $settings = $null
    if (Test-Path $settingsPath) {
        $raw = Get-Content $settingsPath -Raw -Encoding UTF8
        $settings = $raw | ConvertFrom-Json
    } else {
        $settings = [PSCustomObject]@{}
    }

    if (-not $settings.PSObject.Properties["hooks"]) {
        $settings | Add-Member -MemberType NoteProperty -Name "hooks" -Value ([PSCustomObject]@{}) -Force
    }

    $hooksObj = $settings.hooks
    if (-not $hooksObj.PSObject.Properties["SessionStart"]) {
        $hooksObj | Add-Member -MemberType NoteProperty -Name "SessionStart" -Value @([PSCustomObject]@{ hooks = @() }) -Force
    }

    $sessionStart = $settings.hooks.SessionStart[0]
    if (-not $sessionStart.PSObject.Properties["hooks"]) {
        $sessionStart | Add-Member -MemberType NoteProperty -Name "hooks" -Value @() -Force
    }

    $alreadyRegistered = $false
    foreach ($h in $sessionStart.hooks) {
        if ($h.command -like "*global-orchestrator.mjs*") { $alreadyRegistered = $true }
    }

    if (-not $alreadyRegistered) {
        $newHook = [PSCustomObject]@{ type = "command"; command = $hookCmd }
        $sessionStart.hooks = @($sessionStart.hooks) + @($newHook)
        $json = ConvertTo-Json $settings -Depth 20
        Set-Content -Path $settingsPath -Value $json -Encoding UTF8
        Write-Host "  [OK]  Hook registered in settings.json"
    } else {
        Write-Host "  [OK]  Hook already registered -- skipped"
    }
} catch {
    Write-Warning "  Failed to update settings.json: $_"
    if ($backupPath -and (Test-Path $backupPath)) {
        Copy-Item $backupPath $settingsPath -Force
        Write-Host "  [ROLLBACK] settings.json restored from backup"
    }
}
Write-Host ""

# --- Register PowerShell alias -----------------------------------------------
Write-Host "[4/4] Registering PowerShell alias..."

if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force > $null
}

$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
$aliasSetup  = "Set-Alias setup-karpathy `"$localBin\setup-karpathy.ps1`""
$aliasUpdate = "function gair-update { & `"$localBin\global-ai-rules-update.ps1`" }"
$aliasBlock  = "`n# --- Global AI Rules ---`n$aliasSetup`n$aliasUpdate`n# -----------------------"

if ($profileContent -notlike "*Global AI Rules*") {
    Add-Content -Path $PROFILE -Value $aliasBlock -Encoding UTF8
    Write-Host "  [OK]  Alias 'setup-karpathy' added to PowerShell profile"
    Write-Host "  [OK]  Command 'gair-update' added (self-update from GitHub)"
} else {
    Write-Host "  [OK]  Aliases already present in profile"
}

# --- Summary -----------------------------------------------------------------
Write-Host ""
Write-Host "================================================================="
Write-Host "  INSTALLATION COMPLETE"
Write-Host "================================================================="
Write-Host ""
Write-Host "  What's installed:"
Write-Host "    - Session hook auto-runs at every Claude Code startup"
Write-Host "    - 8 project archetypes with smart detection"
Write-Host "    - 'setup-karpathy' command for any project directory"
Write-Host "    - 'gair-update' command for self-update from GitHub"
Write-Host ""
Write-Host "  Next steps:"
Write-Host "    1. Reload your terminal: . `$profile"
Write-Host "    2. Open Claude Code in any project -- hook auto-runs"
Write-Host "    3. Or run manually: setup-karpathy"
Write-Host ""
if ($backupPath) {
    Write-Host "  Backup: $backupPath"
}
Write-Host "================================================================="
Write-Host ""
