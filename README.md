# Global AI Rules — Dynamic Rules Generator for AI Coding Agents

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)](#)
[![AI Supported: Cursor | Windsurf | Claude Code | Copilot](https://img.shields.io/badge/AI--Supported-Cursor%20%7C%20Windsurf%20%7C%20Claude%20%7C%20Copilot-green.svg)](#)

[Français](#version-française) | [English](#english-version)

---

## Version Française

**`global-ai-rules`** est un framework universel et open-source pour Windows conçu pour **auto-configurer et discipliner n'importe quel assistant de codage IA** (Cursor, Windsurf, Claude Code, GitHub Copilot, ChatGPT) au démarrage de tes sessions et selon l'archétype de ton projet.

Inspiré des retours d'expérience d'**Andrej Karpathy**, il automatise l'injection de directives de codage rigoureuses pour éviter la sur-ingénierie (*over-engineering*), les modifications inutiles de fichiers adjacents et les régressions de code.

### 🌟 Fonctionnalités

1. **Générateur Universel de Règles :** Génère simultanément les fichiers `.cursorrules`, `.windsurfrules` et `CLAUDE.md` personnalisés pour ton projet.
2. **Auto-Détection d'Archétype :** Scanne ton répertoire de travail et adapte dynamiquement les consignes selon le projet :
   * 🧠 **AI Research & Deep Learning :** Optimisation GPU, boucle Ratchet (Git Commit/Reset auto).
   * 🕸️ **Web Scraping & Crawling :** Crawl4AI, suppression de pubs et popups cookies.
   * 🛍️ **E-Commerce & Création de Contenus :** Ligne éditoriale premium, multimédia (FFmpeg, ImageMagick).
   * 🎨 **Premium Web UI Frontend :** Design systèmes en HSL, micro-animations, rejet de templates génériques.
3. **Hook Automatique (Claude Code) :** Injecte instantanément le contexte du projet, les compétences à privilégier et les serveurs MCP recommandés au tout début de la conversation.

### 🚀 Installation Rapide (Windows)

1. Ouvre ton terminal PowerShell en mode Administrateur et clone ce dépôt :
   ```powershell
   git clone https://github.com/ton-pseudo/global-ai-rules.git
   cd global-ai-rules
   ```
2. Lance l'installateur automatisé en 1-clic :
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File .\install.ps1
   ```
3. Recharge ton terminal ou exécute `. $profile` pour activer la commande globale.

### 📖 Utilisation

* **Automatique :** Lance une session dans n'importe quel dossier de ton PC. L'IA s'auto-configure en arrière-plan et t'accueille avec les compétences adaptées !
* **Manuel :** Saisis simplement la commande suivante dans n'importe quel projet pour créer/mettre à jour les fichiers de règles pour toutes tes IA :
  ```powershell
  setup-karpathy
  ```

---

## English Version

**`global-ai-rules`** is a universal, open-source framework for Windows designed to **auto-configure and discipline any AI coding agent** (Cursor, Windsurf, Claude Code, GitHub Copilot, ChatGPT) at session start, tailored dynamically to your active project type.

Inspired by **Andrej Karpathy's** observations, it automates the injection of strict coding guidelines to eliminate over-engineering, sloppy adjacent edits, and code regressions.

### 🌟 Key Features

1. **Multi-AI Rules Generator:** Generates project-specific `.cursorrules`, `.windsurfrules`, and `CLAUDE.md` files at once.
2. **Dynamic Archetype Diagnostics:** Instantly scans your active directory and customizes constraints:
   * 🧠 **AI Research & Deep Learning:** CUDA/GPU tuning, Ratchet loop constraints (Git Commit/Reset).
   * 🕸️ **Web Scraping & Crawling:** Crawl4AI extraction specs, automated clutter/cookie popups bypass.
   * 🛍️ **E-Commerce & Digital Content:** High-end premium styling guidelines, multimedia automation.
   * 🎨 **Premium Web UI Frontend:** Bespoke CSS design systems, dynamic micro-motions, anti-template directives.
3. **Automated Session Start Hook:** Injects active project context, recommended local skills, and MCP configurations straight into your AI's system memory.

### 🚀 Quick Start (Windows)

1. Open your PowerShell terminal and clone the repository:
   ```powershell
   git clone https://github.com/your-username/global-ai-rules.git
   cd global-ai-rules
   ```
2. Execute the 1-click master installer:
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File .\install.ps1
   ```
3. Restart your terminal or run `. $profile` to register the new system path.

### 📖 How to Use

* **Automated Mode:** Open any directory on your computer and start a session. The AI instantly auto-configures its environment!
* **Manual Setup:** Run this command in any active directory to instantly deploy or merge rules files for all your AIs:
  ```powershell
  setup-karpathy
  ```

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
