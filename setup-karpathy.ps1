# setup-karpathy.ps1 - Generateur universel de regles pour assistants IA (Cursor, Windsurf, Claude, Copilot)
param(
    [switch]$Force
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$karpathyFile = Join-Path $scriptPath "CLAUDE.md"

if (-not (Test-Path $karpathyFile)) {
    # Fallback si installe globalement
    $karpathyFile = "$env:USERPROFILE\.local\bin\global-ai-rules\CLAUDE.md"
}

if (-not (Test-Path $karpathyFile)) {
    Write-Error "Fichier source CLAUDE.md non trouve."
    exit 1
}

# 1. Diagnostic dynamique de l'archetype de projet
$cwd = Get-Location
$files = Get-ChildItem -Name
$projectType = "Standard Workspace"
$description = "Espace de travail generique. Adopte une approche rigoureuse et de haute qualite."
$customDirectives = @()

# Diagnostic : AI Research / Deep Learning
if (($files -contains "train.py") -or ($files -contains "prepare.py") -or ($cwd.Path.ToLower().Contains("autoresearch"))) {
    $projectType = "AI Deep Learning Research (Autoresearch)"
    $description = "Projet de recherche et d'entrainement autonome de modeles de Deep Learning."
    $customDirectives = @(
        "- Prioriser l'optimisation des performances de calcul (ex: NVIDIA CUDA, batching intelligent).",
        "- Adopter scrupuleusement le principe de la boucle 'Ratchet' (Modifier -> Entrainer -> Evaluer -> Committer ou Reset Git).",
        "- Limiter les modifications de code aux seuls fichiers d'experimentation active."
    )
}
# Diagnostic : Web Scraping & Crawling
elseif (($files -contains "scrape.py") -or ($files -contains "lotus_scraper") -or ($cwd.Path.ToLower().Contains("scraper"))) {
    $projectType = "Web Scraping Suite (LotusScraper)"
    $description = "Suite premium de crawling asynchrone et d'extraction de donnees LLM-Ready."
    $customDirectives = @(
        "- Privilegier l'extraction Markdown propre et structuree (ex: via Crawl4AI ou Playwright).",
        "- Mettre en place des filtres anti-bruit rigoureux (supprimer cookies, headers, footers et publicités).",
        "- Stocker systematiquement les donnees extraites localement dans le projet."
    )
}
# Diagnostic : E-Commerce & Content Creation
elseif (($files -contains "moneyprinterturbo") -or ($files -contains "etsy_ready") -or ($cwd.Path.ToLower().Contains("ecommerce")) -or ($cwd.Path.ToLower().Contains("content"))) {
    $projectType = "E-Commerce & Digital Content Creation"
    $description = "Espace e-commerce et chaine de creation automatisee de contenus digitaux."
    $customDirectives = @(
        "- Maintenir une ligne editoriale et visuelle de marque haut de gamme (premium, esthetique epuree).",
        "- Valider les configurations portables de traitement multimedia (FFmpeg, ImageMagick).",
        "- Optimiser les contenus et fiches produits pour un SEO riche en mots-cles tout en gardant une plume elegante."
    )
}
# Diagnostic : Web/Frontend standard
elseif (($files -contains "index.html") -or ($files -contains "package.json") -or ($files -contains "index.css")) {
    $projectType = "Web UI Premium Frontend"
    $description = "Projet de developpement web et d'interface utilisateur responsive."
    $customDirectives = @(
        "- Proposer des interfaces fluides, epurees et elegantes. Bannir les designs IA generiques standardises.",
        "- Etablir un systeme de design CSS structure avec des palettes de couleurs HSL harmonieuses.",
        "- Integrer des micro-animations interactives fluides pour ameliorer l'engagement utilisateur."
    )
}

# 2. Construction du fichier de regles localise
$karpathyContent = Get-Content $karpathyFile -Raw
$ruleHeader = @"
# AI ORCHESTRATION RULES (Auto-Generated)
# Archetype de projet detecte : $projectType
# Description : $description

$karpathyContent

## Project-Specific Guidelines

"@

foreach ($dir in $customDirectives) {
    $ruleHeader += "$dir`n"
}

# 3. Ecriture simultanee pour toutes les IA du marche
$targetFiles = @("CLAUDE.md", ".cursorrules", ".windsurfrules")

foreach ($target in $targetFiles) {
    if ((Test-Path $target) -and -not $Force) {
        Write-Host "[Karpathy] Un fichier $target existe deja. Utilisez -Force pour forcer l'ecrasement."
    } else {
        Set-Content -Path $target -Value $ruleHeader -Encoding UTF8
        Write-Host "✓ Fichier $target genere avec succes."
    }
}

Write-Host "`n📚 4 Principes Karpathy et directives specifiques deployes pour toutes les IA !"
