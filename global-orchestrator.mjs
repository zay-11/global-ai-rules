#!/usr/bin/env node
// =============================================================================
//  GlobalOrchestrator v2.0 — Production-grade AI Session Context Engine
//  github.com/zay-11/global-ai-rules
// =============================================================================

import { existsSync, readFileSync, copyFileSync, readdirSync } from "fs";
import { join, basename, extname } from "path";

const VERSION = "2.0.0";
const cwd = process.cwd();
const userProfile = process.env.USERPROFILE || process.env.HOME || "";
const installDir = join(userProfile, ".local", "bin", "global-ai-rules");

// --- Config Loading ----------------------------------------------------------

function loadArchetypes() {
  const searchPaths = [
    join(cwd, "archetypes.json"),
    join(installDir, "archetypes.json"),
    join(userProfile, ".claude", "global-ai-rules", "archetypes.json"),
  ];
  for (const p of searchPaths) {
    if (existsSync(p)) {
      try {
        const raw = JSON.parse(readFileSync(p, "utf8"));
        if (raw.archetypes && Array.isArray(raw.archetypes)) return raw;
      } catch {}
    }
  }
  return null;
}

// --- Project Scanner ---------------------------------------------------------

function scanProject() {
  let files = [];
  try { files = readdirSync(cwd); } catch {}

  const filesLower = new Set(files.map(f => f.toLowerCase()));
  const extensions = new Set(files.map(f => extname(f).toLowerCase()));
  const dirName = basename(cwd).toLowerCase();

  let requirements = [];
  try {
    const raw = readFileSync(join(cwd, "requirements.txt"), "utf8");
    requirements = raw
      .split("\n")
      .map(l => l.split(/[>=<!# \t]/)[0].trim().toLowerCase())
      .filter(Boolean);
  } catch {}

  let jsDeps = [];
  try {
    const pkg = JSON.parse(readFileSync(join(cwd, "package.json"), "utf8"));
    const allDeps = { ...pkg.dependencies, ...pkg.devDependencies, ...pkg.peerDependencies };
    jsDeps = Object.keys(allDeps).map(k => k.replace(/^@[^/]+\//, "").toLowerCase());
  } catch {}

  let claudeContent = "";
  try { claudeContent = readFileSync(join(cwd, "CLAUDE.md"), "utf8").toLowerCase(); } catch {}

  let readmeContent = "";
  try { readmeContent = readFileSync(join(cwd, "README.md"), "utf8").toLowerCase(); } catch {}

  return { files, filesLower, extensions, dirName, requirements, jsDeps, claudeContent, readmeContent };
}

// --- Archetype Scorer --------------------------------------------------------

function scoreArchetype(archetype, scan) {
  const { filesLower, extensions, dirName, requirements, jsDeps, claudeContent, readmeContent } = scan;
  let score = 0;
  const m = archetype.match || {};

  for (const f of (m.files || [])) {
    const name = f.includes("/") ? f.split("/").pop().toLowerCase() : f.toLowerCase();
    if (filesLower.has(name)) score += 3;
    if (filesLower.has(f.toLowerCase())) score += 2;
  }

  for (const req of (m.requirements || [])) {
    if (requirements.includes(req.toLowerCase())) score += 2;
  }

  for (const dep of (m.requirements_js || [])) {
    if (jsDeps.includes(dep.toLowerCase())) score += 2;
  }

  for (const dir of (m.dirs || [])) {
    if (dirName.includes(dir.toLowerCase())) score += 2;
  }

  for (const ext of (m.file_extensions || [])) {
    if (extensions.has(ext.toLowerCase())) score += 1;
  }

  let contentHits = 0;
  const searchTargets = claudeContent + " " + readmeContent;
  for (const kw of (m.content_search || [])) {
    if (searchTargets.includes(kw.toLowerCase()) && contentHits < 4) {
      score += 1;
      contentHits++;
    }
  }

  return score;
}

// --- Auto-Install CLAUDE.md --------------------------------------------------

function autoInstallClaudeMd() {
  const target = join(cwd, "CLAUDE.md");
  const source = join(installDir, "CLAUDE.md");
  if (!existsSync(target) && existsSync(source)) {
    try { copyFileSync(source, target); return true; } catch {}
  }
  return false;
}

// --- Main --------------------------------------------------------------------

const archetypesConfig = loadArchetypes();
const scan = scanProject();
const installed = autoInstallClaudeMd();

let detected = null;
let bestScore = 0;

if (archetypesConfig) {
  for (const archetype of archetypesConfig.archetypes) {
    const score = scoreArchetype(archetype, scan);
    if (score > bestScore) {
      bestScore = score;
      detected = { ...archetype, score };
    }
  }
}

if (!detected) {
  detected = {
    name: "Standard Workspace",
    description: "Espace de travail generique. Standards d'ingenierie eleves.",
    skills: ["lean-code", "autonomous-team"],
    mcp: [],
    directives: [],
    score: 0,
  };
}

// --- Render ------------------------------------------------------------------

const L = "=".repeat(71);
const S = "-".repeat(71);
const scoreTag = detected.score > 0 ? ` [score:${detected.score}]` : "";

console.log(`\n${L}`);
console.log(`  GLOBAL AI RULES v${VERSION} — SESSION ORCHESTRATION`);
console.log(L);
console.log(`  Project   : ${basename(cwd)}`);
console.log(`  Archetype : ${detected.name}${scoreTag}`);
console.log(`  Context   : ${detected.description}`);
if (installed) console.log(`  Note      : CLAUDE.md auto-deployed from global template`);
console.log(S);

if (detected.skills?.length) {
  console.log(`  RECOMMENDED SKILLS:`);
  for (const s of detected.skills) console.log(`    + ${s}`);
}

if (detected.mcp?.length) {
  console.log(S);
  console.log(`  MCP SERVERS:`);
  for (const m of detected.mcp) console.log(`    * ${m}`);
}

console.log(S);
console.log(`  BEHAVIORAL DIRECTIVES:`);
const baseRules = [
  "Think Before Coding   — Never assume. Ask for clarification before starting.",
  "Simplicity First      — Minimum code. Zero over-engineering.",
  "Surgical Changes      — Modify only what is asked. Touch nothing else.",
  "Goal-Driven Execution — Define success criteria. Test and verify iteratively.",
];
for (const r of baseRules) console.log(`    > ${r}`);

if (detected.directives?.length) {
  console.log(S);
  console.log(`  PROJECT-SPECIFIC RULES:`);
  for (const d of detected.directives) console.log(`    > ${d}`);
}

console.log(L);
console.log();
