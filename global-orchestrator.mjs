#!/usr/bin/env node
// =====================================================================
//  GlobalOrchestrator - Dynamic AI Session Orchestration Hook
//  Designed for Windows Developer Workspaces
// =====================================================================

import { existsSync, copyFileSync, readdirSync } from "fs";
import { join, basename } from "path";

const cwd = process.cwd();
const userProfile = process.env.USERPROFILE || process.env.HOME || "C:\\Users";
const karpathySource = join(userProfile, ".local\\bin\\global-ai-rules\\CLAUDE.md");
const localClaudeMd = join(cwd, "CLAUDE.md");

// 1. Auto-Installation of Karpathy Guidelines (CLAUDE.md)
if (!existsSync(localClaudeMd) && existsSync(karpathySource)) {
    try {
        copyFileSync(karpathySource, localClaudeMd);
        console.log("✓ [GlobalOrchestrator] Karpathy Guidelines (CLAUDE.md) auto-applied to this workspace.");
    } catch (e) {
        // Silently fail
    }
}

// 2. Directory Scan & Project Archetype Diagnostics
let files = [];
try {
    files = readdirSync(cwd);
} catch (e) {
    // Fallback
}

let projectType = "Standard Workspace";
let description = "Generic workspace. Maintain high engineering standards and clean code.";
let recommendedSkills = ["autonomous-team", "lean-code"];
let recommendedMCP = ["chrome-devtools-mcp"];
let customDirectives = [];

const filesLower = files.map(f => f.toLowerCase());

// Archetype : AI Deep Learning Research
if (filesLower.includes("train.py") || filesLower.includes("prepare.py") || cwd.toLowerCase().includes("autoresearch")) {
    projectType = "AI Deep Learning Research";
    description = "Autonomous machine learning pretraining and experimentation workflow.";
    recommendedSkills = ["py-diagnose", "rigorous-math-verifier", "autonomous-team", "lean-code"];
    customDirectives = [
        "- Prioritize deep learning performance tuning (e.g., PyTorch CUDA, efficient batching).",
        "- Strictly adhere to the 'Ratchet' loop (Modify train.py -> Train -> Evaluate -> Commit or Reset).",
        "- Do not modify core infrastructure files unless explicitly requested."
    ];
}
// Archetype : Web Scraping & Crawling
else if (filesLower.includes("scrape.py") || filesLower.includes("scraper") || cwd.toLowerCase().includes("scraper")) {
    projectType = "Web Scraping Suite";
    description = "High-performance data gathering, crawling and markdown parsing using Crawl4AI/Playwright.";
    recommendedSkills = ["py-diagnose", "autonomous-team", "lean-code"];
    customDirectives = [
        "- Utilize async Markdown parsing to output clean, structured data for LLM contexts.",
        "- Apply robust filtering protocols (remove cookies consent, headers, footers, ads).",
        "- Save output locally within the active project directory under scraped_pages/."
    ];
}
// Archetype : E-Commerce & Content Creation
else if (filesLower.includes("moneyprinterturbo") || filesLower.includes("etsy_ready") || filesLower.includes("config.toml") || cwd.toLowerCase().includes("ecommerce") || cwd.toLowerCase().includes("content")) {
    projectType = "E-Commerce & Digital Content Creation";
    description = "Digital product management, video automation and online store content optimization.";
    recommendedSkills = ["design-taste-frontend", "brandkit", "autonomous-team", "lean-code"];
    customDirectives = [
        "- Maintain high-end editorial and premium visual branding guidelines (minimalist, clean).",
        "- Verify portable multimedia rendering paths (FFmpeg, ImageMagick).",
        "- Optimize online store descriptions for high SEO keyword density while keeping an elegant tone."
    ];
}
// Archetype : Standard Web Frontend
else if (filesLower.includes("index.html") || filesLower.includes("package.json") || filesLower.includes("index.css")) {
    projectType = "Web UI Premium Frontend";
    description = "Responsive web development and user interface design.";
    recommendedSkills = ["design-taste-frontend", "gpt-taste", "minimalist-ui"];
    customDirectives = [
        "- Avoid generic, cookie-cutter templates. Implement clean, bespoke and highly-polished UI.",
        "- Establish a strict, structured CSS design system using curated HSL color palettes.",
        "- Integrate smooth micro-animations for high-quality interactive feedback."
    ];
}

// 3. Injecting Context into the LLM Memory
console.log(`\n=====================================================================`);
console.log(`🧠 [SYSTEM ORCHESTRATION] CONTEXT DETECTED BY GLOBALORCHESTRATOR`);
console.log(`=====================================================================`);
console.log(`📍 Active Project    : ${basename(cwd)}`);
console.log(`🏷️ Archetype         : ${projectType}`);
console.log(`📖 Description       : ${description}`);
console.log(`---------------------------------------------------------------------`);
console.log(`🛠️ RECOMMENDED LOCAL SKILLS TO ACTIVATE :`);
recommendedSkills.forEach(skill => {
    console.log(`  ✓ Skill : ${skill}`);
});
if (recommendedMCP.length > 0) {
    console.log(`---------------------------------------------------------------------`);
    console.log(`🔌 COMPATIBLE MCP SERVERS TO USE :`);
    recommendedMCP.forEach(mcp => {
        console.log(`  🔌 MCP  : ${mcp}`);
    });
}
console.log(`---------------------------------------------------------------------`);
console.log(`📜 BEHAVIORAL DIRECTIVES & CONSTRAINTS :`);
console.log(`  1. Think Before Coding   - Never assume. Ask for clarification before starting.`);
console.log(`  2. Simplicity First      - Minimum code. Zero over-engineering or speculative code.`);
console.log(`  3. Surgical Changes      - Modify only what is asked. Do not touch unrelated code.`);
console.log(`  4. Goal-Driven Execution - Define success criteria. Test and verify iteratively.`);
customDirectives.forEach(dir => {
    console.log(`  ${dir}`);
});
console.log(`=====================================================================\n`);
