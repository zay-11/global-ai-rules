# install.ps1 - Installateur Systeme Automatique en 1-clic pour global-ai-rules
$ErrorActionPreference = "Stop"

Write-Host "====================================================================="
Write-Host "  INSTALLATION GLOBALE - GLOBAL-AI-RULES"
Write-Host "====================================================================="
Write-Host ""

$userProfile = $env:USERPROFILE
$localBin = Join-Path $userProfile ".local\bin"
$claudeHooks = Join-Path $userProfile ".claude\hooks"
$settingsJsonPath = Join-Path $userProfile ".claude\settings.json"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 1. Creation des dossiers
if (-not (Test-Path $localBin)) {
    New-Item -ItemType Directory -Path $localBin -Force > $null
    Write-Host "[OK] Repertoire local bin cree : $localBin"
}
if (-not (Test-Path $claudeHooks)) {
    New-Item -ItemType Directory -Path $claudeHooks -Force > $null
    Write-Host "[OK] Repertoire local hooks cree : $claudeHooks"
}

# 2. Deploiement des fichiers
Write-Host "[1/3] Deploiement des scripts systeme..."
$globalRulesDir = Join-Path $localBin "global-ai-rules"
if (-not (Test-Path $globalRulesDir)) {
    New-Item -ItemType Directory -Path $globalRulesDir -Force > $null
}

Copy-Item (Join-Path $scriptDir "CLAUDE.md") (Join-Path $globalRulesDir "CLAUDE.md") -Force
Copy-Item (Join-Path $scriptDir "setup-karpathy.ps1") (Join-Path $localBin "setup-karpathy.ps1") -Force
Copy-Item (Join-Path $scriptDir "global-orchestrator.mjs") (Join-Path $claudeHooks "global-orchestrator.mjs") -Force

Write-Host "  [OK] CLAUDE.md source installe dans : $globalRulesDir"
Write-Host "  [OK] setup-karpathy.ps1 installe dans : $localBin"
Write-Host "  [OK] global-orchestrator.mjs installe dans : $claudeHooks"

# 3. Modification de settings.json
Write-Host ""
Write-Host "[2/3] Integration dans la configuration de Claude Code..."

$orchestratorCommand = "node " + '"' + $userProfile + '\.claude\hooks\global-orchestrator.mjs"'

if (Test-Path $settingsJsonPath) {
    try {
        $settingsRaw = Get-Content $settingsJsonPath -Raw -Encoding UTF8
        $settings = ConvertFrom-Json $settingsRaw
        
        # S'assurer de la structure de base
        if (-not $settings.PSObject.Properties["hooks"]) {
            $settings | Add-Member -MemberType NoteProperty -Name "hooks" -Value @{} -Force
        }
        if (-not $settings.hooks.PSObject.Properties["SessionStart"]) {
            $settings.hooks | Add-Member -MemberType NoteProperty -Name "SessionStart" -Value @( @{ hooks = @() } ) -Force
        }
        
        $sessionStart = $settings.hooks.SessionStart[0]
        if (-not $sessionStart.PSObject.Properties["hooks"]) {
            $sessionStart | Add-Member -MemberType NoteProperty -Name "hooks" -Value @() -Force
        }
        
        # Filtrer et verifier la presence
        $newHooks = @()
        $alreadyExists = $false
        foreach ($h in $sessionStart.hooks) {
            if ($h.command -like "*global-orchestrator.mjs*") {
                $alreadyExists = $true
            }
            if ($h.command -notlike "*auto-karpathy.mjs*") {
                $newHooks += $h
            }
        }
        
        if (-not $alreadyExists) {
            $newHook = @{
                type = "command"
                command = $orchestratorCommand
            }
            $newHooks += $newHook
            $sessionStart.hooks = $newHooks
            
            $updatedJson = ConvertTo-Json $settings -Depth 100
            Set-Content -Path $settingsJsonPath -Value $updatedJson -Encoding UTF8
            Write-Host "  [OK] Hook global-orchestrator active avec succes dans ton settings.json !"
        } else {
            Write-Host "  [OK] Hook global-orchestrator deja configure dans settings.json."
        }
    } catch {
        Write-Warning "Impossible de faire la configuration automatiquement. Renseigne manuellement le hook dans ton settings.json."
    }
} else {
    $defaultSettings = '{"hooks":{"SessionStart":[{"hooks":[{"type":"command","command":"' + $orchestratorCommand.Replace("\", "\\") + '"}]}]}}'
    Set-Content -Path $settingsJsonPath -Value $defaultSettings -Encoding UTF8
    Write-Host "  [OK] Nouveau fichier settings.json cree et active avec success !"
}

# 4. Enregistrement de l'alias dans le profil
Write-Host ""
Write-Host "[3/3] Configuration du raccourci PowerShell..."
$aliasLine = "Set-Alias setup-karpathy " + '"' + $localBin + '\setup-karpathy.ps1"'

if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force > $null
}

$profileContent = Get-Content $PROFILE -Raw
if ($profileContent -notlike "*setup-karpathy*") {
    Add-Content -Path $PROFILE -Value "`n# Global AI Rules Alias`n$aliasLine"
    Write-Host "  [OK] Raccourci setup-karpathy ajoute a ton profil PowerShell !"
    Write-Host "  -> Pour charger ce raccourci, execute : . `$profile"
} else {
    Write-Host "  [OK] Raccourci setup-karpathy deja present dans ton profil."
}

Write-Host ""
Write-Host "====================================================================="
Write-Host "  ARCHITECTURE AUTO-GENERATRICE INSTALLEE AVEC SUCCES !"
Write-Host "====================================================================="
Write-Host "  Toutes les IA (Cursor, Windsurf, Claude Code, Copilot, etc.)"
Write-Host "  profiteront desormais de regles locales intelligentes dans tes projets !"
Write-Host "====================================================================="
Write-Host ""
