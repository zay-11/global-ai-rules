#!/usr/bin/env node
// test-archetypes.mjs — Test suite for archetype detection logic
// Run: node test-archetypes.mjs

import { readFileSync, existsSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dir = dirname(fileURLToPath(import.meta.url));
const PASS = "\x1b[32m[PASS]\x1b[0m";
const FAIL = "\x1b[31m[FAIL]\x1b[0m";

let passed = 0;
let failed = 0;

function assert(condition, label) {
  if (condition) { console.log(`${PASS} ${label}`); passed++; }
  else           { console.log(`${FAIL} ${label}`); failed++; }
}

// --- Load archetypes config --------------------------------------------------
const configPath = join(__dir, "archetypes.json");
assert(existsSync(configPath), "archetypes.json exists");

let config;
try {
  config = JSON.parse(readFileSync(configPath, "utf8"));
  assert(true, "archetypes.json parses as valid JSON");
} catch (e) {
  assert(false, `archetypes.json parses as valid JSON — ${e.message}`);
  process.exit(1);
}

// --- Schema validation -------------------------------------------------------
assert(config.version === "2.0", `config.version is "2.0"`);
assert(Array.isArray(config.archetypes), "config.archetypes is an array");
assert(config.archetypes.length >= 4, `at least 4 archetypes defined (got ${config.archetypes.length})`);

for (const arch of config.archetypes) {
  assert(typeof arch.id === "string" && arch.id.length > 0,          `archetype "${arch.id || "?"}" has id`);
  assert(typeof arch.name === "string" && arch.name.length > 0,       `archetype "${arch.id}" has name`);
  assert(typeof arch.description === "string",                         `archetype "${arch.id}" has description`);
  assert(Array.isArray(arch.skills),                                   `archetype "${arch.id}" has skills array`);
  assert(Array.isArray(arch.directives),                               `archetype "${arch.id}" has directives array`);
  assert(typeof arch.match === "object",                               `archetype "${arch.id}" has match object`);
}

// --- Archetype IDs expected --------------------------------------------------
const ids = config.archetypes.map(a => a.id);
const expectedIds = ["deep-learning", "web-scraping", "frontend", "api-backend", "data-science", "devops"];
for (const id of expectedIds) {
  assert(ids.includes(id), `archetype "${id}" is present`);
}

// --- Scorer function (inline copy) ------------------------------------------
function scoreArchetype(archetype, scan) {
  const { filesLower, dirName, requirements, jsDeps, claudeContent } = scan;
  let score = 0;
  const m = archetype.match || {};

  for (const f of (m.files || [])) {
    const name = (f.includes("/") ? f.split("/").pop() : f).toLowerCase();
    if (filesLower.has(name)) score += 3;
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
  let hits = 0;
  for (const kw of (m.content_search || [])) {
    if (claudeContent.includes(kw.toLowerCase()) && hits < 4) { score += 1; hits++; }
  }
  return score;
}

function detectArchetype(scan) {
  let best = null, bestScore = 0;
  for (const arch of config.archetypes) {
    const s = scoreArchetype(arch, scan);
    if (s > bestScore) { bestScore = s; best = arch; }
  }
  return best;
}

// --- Detection tests ---------------------------------------------------------
console.log("\n--- Detection tests ---");

// Deep learning project
const dlScan = {
  filesLower: new Set(["train.py", "prepare.py", "readme.md"]),
  dirName: "my-ml-project",
  requirements: ["torch", "transformers"],
  jsDeps: [],
  claudeContent: ""
};
const dlResult = detectArchetype(dlScan);
assert(dlResult?.id === "deep-learning", `train.py + torch -> deep-learning (got ${dlResult?.id})`);

// Frontend project
const feScan = {
  filesLower: new Set(["package.json", "index.html", "vite.config.ts"]),
  dirName: "my-ui",
  requirements: [],
  jsDeps: ["react", "vite"],
  claudeContent: ""
};
const feResult = detectArchetype(feScan);
assert(feResult?.id === "frontend", `package.json + react -> frontend (got ${feResult?.id})`);

// Devops project
const devScan = {
  filesLower: new Set(["dockerfile", "makefile", "docker-compose.yml"]),
  dirName: "my-infra",
  requirements: [],
  jsDeps: [],
  claudeContent: ""
};
const devResult = detectArchetype(devScan);
assert(devResult?.id === "devops", `Dockerfile + Makefile -> devops (got ${devResult?.id})`);

// Standard fallback (no match)
const stdScan = {
  filesLower: new Set(["random.txt"]),
  dirName: "random-dir",
  requirements: [],
  jsDeps: [],
  claudeContent: ""
};
const stdResult = detectArchetype(stdScan);
assert(stdResult === null, `no signals -> no archetype detected (fallback to Standard)`);

// --- Orchestrator script exists ----------------------------------------------
console.log("\n--- File checks ---");
assert(existsSync(join(__dir, "global-orchestrator.mjs")), "global-orchestrator.mjs exists");
assert(existsSync(join(__dir, "setup-karpathy.ps1")),       "setup-karpathy.ps1 exists");
assert(existsSync(join(__dir, "install.ps1")),              "install.ps1 exists");
assert(existsSync(join(__dir, "uninstall.ps1")),            "uninstall.ps1 exists");
assert(existsSync(join(__dir, "update.ps1")),               "update.ps1 exists");
assert(existsSync(join(__dir, "CLAUDE.md")),                "CLAUDE.md exists");

// --- Summary -----------------------------------------------------------------
console.log(`\n${"=".repeat(50)}`);
console.log(`  Results: ${passed} passed, ${failed} failed`);
console.log("=".repeat(50));
process.exit(failed > 0 ? 1 : 0);
