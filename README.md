# Global AI Rules v2.0 — Dynamic Rules Engine for AI Coding Agents

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)](#)
[![AI: Cursor | Windsurf | Claude Code | Copilot](https://img.shields.io/badge/AI-Cursor%20%7C%20Windsurf%20%7C%20Claude%20%7C%20Copilot-green.svg)](#)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](#)

[Français](#version-française) | [English](#english-version)

---

## Version Française

### Le problème que ca résout

Par défaut, quand tu ouvres Claude Code, Cursor ou Windsurf dans un projet, l'IA ne sait pas dans quel contexte elle se trouve. Elle doit deviner. Résultat : elle sur-ingénierie, touche du code qu'elle ne devrait pas toucher, propose des solutions inadaptées, et tu passes les 10 premières minutes de chaque session à la recadrer.

**global-ai-rules règle ça automatiquement.**

C'est un système qui **brief ton IA à chaque démarrage de session**, en fonction du projet dans lequel tu travailles — comme un fichier de mission qui se génère tout seul.

---

### Ce qui se passe concrètement après l'installation

#### Au démarrage de chaque session (automatique, zéro action requise)

```
Tu ouvres Claude Code dans un dossier
        |
        v
Le hook SessionStart se déclenche en arrière-plan
        |
        v
Le projet est scanné (fichiers, requirements.txt, package.json...)
        |
        v
Le type de projet est détecté automatiquement
        |
        v
Les directives adaptées sont injectées dans la session
```

Ce que tu vois dans la console au démarrage :

```
=======================================================================
  GLOBAL AI RULES v2.0 -- SESSION ORCHESTRATION
=======================================================================
  Project   : mon-projet-react
  Archetype : Web UI Premium Frontend [score:7]
  Context   : Interfaces web responsives et design systems avances.
-----------------------------------------------------------------------
  RECOMMENDED SKILLS:
    + design-taste-frontend
    + minimalist-ui
-----------------------------------------------------------------------
  BEHAVIORAL DIRECTIVES:
    > Think Before Coding -- Never assume. Ask before starting.
    > Simplicity First    -- Minimum code. Zero over-engineering.
    > Surgical Changes    -- Modify only what is asked.
  PROJECT-SPECIFIC RULES:
    > Design epure et bespoke -- aucun template IA generique.
    > Systeme CSS en HSL avec variables custom properties.
=======================================================================
```

**L'IA lit ce brief au démarrage et adapte immédiatement son comportement.**

---

### Les 7 types de projets détectés automatiquement

| Si tu travailles sur... | Signaux détectés | L'IA recoit les règles pour... |
|---|---|---|
| Réseau de neurones, ML | `train.py`, `torch`, `transformers` | Deep Learning — boucle Ratchet, CUDA |
| Crawling, extraction de données | `scrape.py`, `crawl4ai`, `playwright` | Web Scraping — Markdown propre, filtres anti-bruit |
| Boutique, contenus digitaux | `config.toml`, keywords etsy/shopify | E-Commerce — branding premium, multimedia |
| Interface web | `package.json`, `react`, `vue`, `next` | Frontend — design épuré, CSS HSL, micro-animations |
| API REST ou GraphQL | `main.py`, `fastapi`, `flask`, `express` | API Backend — validation frontière, logging structuré |
| Analyse de données | `.ipynb`, `pandas`, `numpy`, `plotly` | Data Science — seed fixe, séparation train/test |
| Infrastructure, containers | `Dockerfile`, `docker-compose.yml` | DevOps — moindre privilège, secrets via env vars |
| Aucun signal connu | — | Standard — règles Karpathy génériques |

La détection est basée sur un **score multi-signaux pondéré** : fichiers présents (+3), dépendances dans requirements.txt ou package.json (+2), nom du dossier (+2), contenu de CLAUDE.md (+1). Le projet avec le meilleur score gagne.

---

### Les 4 règles Karpathy (appliquées à tous les projets)

Ces principes s'appliquent toujours, quel que soit le type de projet :

```
1. Think Before Coding   -- Ne jamais supposer. Demander si c'est ambigu.
2. Simplicity First      -- Code minimum. Zéro sur-ingénierie.
3. Surgical Changes      -- Toucher uniquement ce qui est demandé.
4. Goal-Driven Execution -- Critères de succès définis. Tester et vérifier.
```

---

### La commande setup-karpathy (utilisation manuelle)

```powershell
cd mon-projet
setup-karpathy
```

Génère **3 fichiers de règles simultanément** dans le dossier courant :

| Fichier | Utilisé par |
|---|---|
| `CLAUDE.md` | Claude Code |
| `.cursorrules` | Cursor |
| `.windsurfrules` | Windsurf / Codeium |

Les fichiers contiennent les 4 règles Karpathy de base + les directives spécifiques au projet détecté.

---

### Ce que ca change au quotidien

**Avant :** Tu répètes "ne touche pas aux fichiers adjacents", "garde le code simple", "demande avant d'implémenter" à chaque nouvelle session, dans chaque projet.

**Après :** L'IA arrive déjà briefée. Elle connait le contexte, les contraintes, les tools recommandés. Tu économises les 10 premières minutes de chaque session, et tu évites les modifications non demandées.

---

### Installation

**Prérequis :** Node.js — https://nodejs.org (version LTS recommandée)

```powershell
git clone https://github.com/zay-11/global-ai-rules.git
cd global-ai-rules
PowerShell -ExecutionPolicy Bypass -File .\install.ps1
. $profile
```

C'est tout. La prochaine fois que tu ouvres Claude Code dans n'importe quel dossier, le brief s'injecte automatiquement.

---

### Toutes les commandes disponibles

```powershell
# Génère les règles pour le projet courant (CLAUDE.md + .cursorrules + .windsurfrules)
setup-karpathy

# Prévisualise ce qui serait généré, sans rien écrire
setup-karpathy -DryRun

# Force l'écrasement des fichiers déjà existants
setup-karpathy -Force

# Met à jour global-ai-rules depuis GitHub
gair-update

# Désinstalle complètement (retire le hook, les fichiers, les alias)
PowerShell -ExecutionPolicy Bypass -File .\uninstall.ps1
```

---

### Ajouter ton propre archetype

Edite `~/.local/bin/global-ai-rules/archetypes.json` et ajoute un bloc dans le tableau `archetypes` :

```json
{
  "id": "mon-projet",
  "name": "Mon Projet Custom",
  "description": "Description courte affichée au démarrage.",
  "match": {
    "files": ["config.py"],
    "requirements": ["ma-librairie"],
    "dirs": ["nom-de-dossier"],
    "content_search": ["mot-cle-dans-claude-md"]
  },
  "skills": ["lean-code", "py-diagnose"],
  "mcp": [],
  "directives": [
    "Règle spécifique à ton projet — visible par l'IA au démarrage."
  ]
}
```

Aucune connaissance en code requise. Le fichier JSON est rechargé à chaque démarrage de session.

---

### Structure du projet

```
global-ai-rules/
├── archetypes.json          -- 7 archetypes configurables (user-editable)
├── global-orchestrator.mjs  -- Hook de session, tourne au démarrage de Claude Code
├── setup-karpathy.ps1       -- Commande manuelle de génération de règles
├── install.ps1              -- Installateur 1-clic avec backup et rollback
├── uninstall.ps1            -- Désinstallation propre
├── update.ps1               -- Auto-update depuis GitHub
├── test-archetypes.mjs      -- Suite de tests (63 tests)
├── CLAUDE.md                -- Règles Karpathy de base
└── README.md
```

---

## English Version

### The problem it solves

By default, when you open Claude Code, Cursor or Windsurf in a project, the AI has no context about what kind of project it's in. It has to guess. The result: it over-engineers, touches code it shouldn't, and you spend the first 10 minutes of every session correcting it.

**global-ai-rules fixes this automatically.**

It's a system that **briefs your AI at every session start**, based on the project you're working in — like a mission briefing that generates itself.

---

### What concretely happens after installation

#### At every session start (automatic, zero action required)

```
You open Claude Code in a folder
        |
        v
SessionStart hook fires in the background
        |
        v
Project is scanned (files, requirements.txt, package.json...)
        |
        v
Project type is detected automatically
        |
        v
Adapted directives are injected into the session
```

---

### 7 project types detected automatically

| If you're working on... | Detection signals | AI receives rules for... |
|---|---|---|
| Neural networks, ML | `train.py`, `torch`, `transformers` | Deep Learning -- Ratchet loop, CUDA |
| Data crawling | `scrape.py`, `crawl4ai`, `playwright` | Web Scraping -- clean Markdown, noise filters |
| Online store, digital content | `config.toml`, etsy/shopify keywords | E-Commerce -- premium branding, multimedia |
| Web interface | `package.json`, `react`, `vue`, `next` | Frontend -- clean design, HSL CSS, micro-animations |
| REST or GraphQL API | `main.py`, `fastapi`, `flask`, `express` | API Backend -- boundary validation, structured logging |
| Data analysis | `.ipynb`, `pandas`, `numpy`, `plotly` | Data Science -- fixed seed, train/test separation |
| Infrastructure, containers | `Dockerfile`, `docker-compose.yml` | DevOps -- least privilege, secrets via env vars |

---

### Quick Start

**Prerequisites:** Node.js -- https://nodejs.org (LTS recommended)

```powershell
git clone https://github.com/zay-11/global-ai-rules.git
cd global-ai-rules
PowerShell -ExecutionPolicy Bypass -File .\install.ps1
. $profile
```

That's it. The next time you open Claude Code in any folder, the brief injects automatically.

---

### Commands

```powershell
setup-karpathy          # Generate rules for current project
setup-karpathy -DryRun  # Preview without writing anything
setup-karpathy -Force   # Overwrite existing files
gair-update             # Self-update from GitHub
```

---

### Running Tests

```powershell
node test-archetypes.mjs
# Expected: 63 passed, 0 failed
```

---

## License

MIT License — see LICENSE file.
