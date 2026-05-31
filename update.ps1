# update.ps1 — Self-update global-ai-rules from GitHub
$ErrorActionPreference = "Stop"

$repoUrl   = "https://github.com/zay-11/global-ai-rules.git"
$tmpDir    = Join-Path $env:TEMP "global-ai-rules-update-$(Get-Date -Format 'yyyyMMddHHmmss')"

Write-Host ""
Write-Host "================================================================="
Write-Host "  GLOBAL AI RULES — SELF UPDATE"
Write-Host "================================================================="
Write-Host ""
Write-Host "  Fetching latest from GitHub..."

try {
    git clone --depth 1 $repoUrl $tmpDir 2>$null
    Write-Host "  [OK]  Repository cloned to temp"
} catch {
    Write-Error "  Failed to clone repository. Check internet connection."
    return
}

Write-Host "  Running installer from latest version..."
Write-Host ""

& (Join-Path $tmpDir "install.ps1")

Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "  Update complete."
Write-Host "================================================================="
Write-Host ""
