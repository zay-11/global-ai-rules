# Global AI Rules v2.0 — Dynamic Rules Engine for AI Coding Agents

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)](#)
[![AI: Cursor | Windsurf | Claude Code | Copilot](https://img.shields.io/badge/AI-Cursor%20%7C%20Windsurf%20%7C%20Claude%20%7C%20Copilot-green.svg)](#)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](#)

[Français](#version-française) | [English](#english-version)

---

## Version Française

**`global-ai-rules`** est un framework Windows open-source qui **auto-configure et discipline n'importe quel assistant IA de codage** (Cursor, Windsurf, Claude Code, GitHub Copilot) à chaque démarrage de session, en détectant automatiquement le type de ton projet.

Inspiré d'Andrej Karpathy, il injecte des directives rigoureuses pour éliminer la sur-ingénierie, les modifications de fichiers adjacents et les régressions de code — **zéro configuration manuelle requise.**

### Fonctionnalités v2.0

| Fonctionnalité | v1 | v2 |
|---|---|---|
| Archetypes détectés | 4 | **8** |
| Détection fichiers | Basique | **Scoring multi-signaux** |
| Scan requirements.txt | Non | **Oui** |
| Scan package.json | Non | **Oui** |
| Archetypes personnalisables | Non (code) | **Oui (archetypes.json)** |
| DryRun avant génération | Non | **Oui** |
| Désinstallation propre | Non | **Oui (uninstall.ps1)** |
| Auto-update depuis GitHub | Non | **Oui (gair-update)** |
| Suite de tests | Non | **Oui (test-archetypes.mjs)** |
| Rollback settings.json | Non | **Oui (backup auto)** |

### Les 8 Archetypes

| ID | Nom | Détecté par |
|---|---|---|
| `deep-learning` | AI Deep Learning Research | `train.py`, `torch`, `transformers` |
| `web-scraping` | Web Scraping Suite | `scrape.py`, `crawl4ai`, `playwright` |
| `ecommerce` | E-Commerce & Digital Content | `config.toml`, keywords etsy/shopify |
| `frontend` | Web UI Premium Frontend | `package.json`, `react`, `vue`, `next` |
| `api-backend` | API Backend Service | `main.py`, `fastapi`, `flask`, `express` |
| `data-science` | Data Science & Analytics | `.ipynb`, `pandas`, `numpy`, `plotly` |
| `devops` | DevOps & Infrastructure | `Dockerfile`, `docker-compose.yml` |

### Installation Rapide

**Prérequis:** Node.js (https://nodejs.org)

```powershell
git clone https://github.com/zay-11/global-ai-rules.git
cd global-ai-rules
PowerShell -ExecutionPolicy Bypass -File .\install.ps1
. $profile
```

### Utilisation

```powershell
# Génère les règles pour le projet courant
setup-karpathy

# Prévisualise sans rien écrire
setup-karpathy -DryRun

# Force l'écrasement des fichiers existants
setup-karpathy -Force

# Met à jour depuis GitHub
gair-update

# Désinstalle complètement
PowerShell -ExecutionPolicy Bypass -File .\uninstall.ps1
```

### Ajouter un archetype personnalisé

Édite `~/.local/bin/global-ai-rules/archetypes.json` :

```json
{
  "id": "mon-projet",
  "name": "Mon Projet Custom",
  "description": "Description du projet.",
  "match": {
    "files": ["config.py"],
    "requirements": ["ma-lib"],
    "dirs": ["mon-dossier"],
    "content_search": ["mot-cle"]
  },
  "skills": ["lean-code", "py-diagnose"],
  "mcp": [],
  "directives": [
    "Règle spécifique à mon projet."
  ]
}
```

### Comment ça marche

Au démarrage de chaque session Claude Code :
1. `global-orchestrator.mjs` s'exécute automatiquement (via hook `SessionStart`)
2. Il scanne le dossier courant : fichiers, `requirements.txt`, `package.json`, contenu `CLAUDE.md`
3. Il score chaque archetype (multi-signaux pondérés)
4. Il injecte dans la session : archetype détecté, skills recommandés, serveurs MCP, directives comportementales

---

## English Version

**`global-ai-rules`** is an open-source Windows framework that **auto-configures any AI coding agent** at session start, dynamically tailored to your active project type. Zero manual configuration.

### Quick Start

**Prerequisites:** Node.js (https://nodejs.org)

```powershell
git clone https://github.com/zay-11/global-ai-rules.git
cd global-ai-rules
PowerShell -ExecutionPolicy Bypass -File .\install.ps1
. $profile
```

### Usage

```powershell
setup-karpathy          # Generate rules for current project
setup-karpathy -DryRun  # Preview without writing
setup-karpathy -Force   # Overwrite existing files
gair-update             # Self-update from GitHub
```

### Running Tests

```powershell
node test-archetypes.mjs
```

---

## File Structure

```
global-ai-rules/
├── archetypes.json          # 8 archetypes config (user-editable)
├── global-orchestrator.mjs  # Session hook — runs at Claude Code startup
├── setup-karpathy.ps1       # Manual rule generator command
├── install.ps1              # 1-click installer with rollback
├── uninstall.ps1            # Clean removal
├── update.ps1               # Self-update from GitHub
├── test-archetypes.mjs      # Test suite
├── CLAUDE.md                # Base behavioral guidelines (Karpathy principles)
└── README.md
```

## License

MIT License — see LICENSE file.
