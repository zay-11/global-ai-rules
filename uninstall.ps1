# uninstall.ps1 — Clean removal of global-ai-rules
$ErrorActionPreference = "SilentlyContinue"

$userProfile  = $env:USERPROFILE
$localBin     = Join-Path $userProfile ".local\bin"
$claudeHooks  = Join-Path $userProfile ".claude\hooks"
$settingsPath = Join-Path $userProfile ".claude\settings.json"
$installDir   = Join-Path $localBin "global-ai-rules"

Write-Host ""
Write-Host "================================================================="
Write-Host "  GLOBAL AI RULES — UNINSTALL"
Write-Host "================================================================="
Write-Host ""

# --- Remove session hook from settings.json ----------------------------------
if (Test-Path $settingsPath) {
    try {
        $raw = Get-Content $settingsPath -Raw -Encoding UTF8
        $settings = $raw | ConvertFrom-Json

        $changed = $false
        if ($settings.hooks?.SessionStart) {
            foreach ($block in $settings.hooks.SessionStart) {
                if ($block.hooks) {
                    $before = $block.hooks.Count
                    $block.hooks = @($block.hooks | Where-Object { $_.command -notlike "*global-orchestrator.mjs*" })
                    if ($block.hooks.Count -ne $before) { $changed = $true }
                }
            }
        }

        if ($changed) {
            $json = ConvertTo-Json $settings -Depth 20
            Set-Content -Path $settingsPath -Value $json -Encoding UTF8
            Write-Host "  [OK]  Hook removed from settings.json"
        } else {
            Write-Host "  [OK]  No hook found in settings.json"
        }
    } catch {
        Write-Warning "  Could not update settings.json: $_"
    }
}

# --- Remove installed files --------------------------------------------------
$filesToRemove = @(
    (Join-Path $claudeHooks "global-orchestrator.mjs"),
    (Join-Path $localBin "setup-karpathy.ps1"),
    (Join-Path $localBin "global-ai-rules-update.ps1")
)

foreach ($f in $filesToRemove) {
    if (Test-Path $f) {
        Remove-Item $f -Force
        Write-Host "  [OK]  Removed: $f"
    }
}

if (Test-Path $installDir) {
    Remove-Item $installDir -Recurse -Force
    Write-Host "  [OK]  Removed: $installDir"
}

# --- Clean PowerShell profile ------------------------------------------------
if (Test-Path $PROFILE) {
    $content = Get-Content $PROFILE -Raw
    $cleaned = $content -replace "(?s)\n# --- Global AI Rules ---.*?# -----------------------", ""
    if ($cleaned -ne $content) {
        Set-Content -Path $PROFILE -Value $cleaned -Encoding UTF8
        Write-Host "  [OK]  Aliases removed from PowerShell profile"
    }
}

Write-Host ""
Write-Host "  Uninstall complete. Reload terminal with: . `$profile"
Write-Host "================================================================="
Write-Host ""
