#!/usr/bin/env bash
# skill-scout installer for Mac / Linux
# One-time, global setup so Claude Code finds and installs the right skills for any project.
# Run:  curl -fsSL https://raw.githubusercontent.com/amirh3sam/skill-scout/main/install.sh | bash
set -e

echo ""
echo "skill-scout: global setup for Claude Code"
echo ""

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is missing. Install the LTS version from https://nodejs.org and run this again."
  exit 1
fi

echo "[1/3] Installing find-skills (by Vercel Labs) globally..."
npx -y skills add vercel-labs/skills --skill find-skills -g -a claude-code -y

echo "[2/3] Allowing 'npx skills' commands in Claude Code..."
DIR="$HOME/.claude"
mkdir -p "$DIR"
SETTINGS="$DIR/settings.json"
node -e '
const fs = require("fs");
const p = process.argv[1];
let s = {};
if (fs.existsSync(p)) { const t = fs.readFileSync(p, "utf8").trim(); if (t) s = JSON.parse(t); }
s.permissions = s.permissions || {};
s.permissions.allow = s.permissions.allow || [];
const rule = "Bash(npx skills:*)";
if (!s.permissions.allow.includes(rule)) s.permissions.allow.push(rule);
fs.writeFileSync(p, JSON.stringify(s, null, 2));
' "$SETTINGS"

echo "[3/3] Adding the 'check for skills first' rule to your global CLAUDE.md..."
MD="$DIR/CLAUDE.md"
touch "$MD"
if ! grep -qF "skill-scout:start" "$MD"; then
  cat >> "$MD" <<'EOF'

<!-- skill-scout:start -->
## Skills
- Before starting a new task, use the find-skills skill to check if a relevant skill exists.
- Show me the top options (name, what it does, install count, source) and wait for my pick before installing.
- Install at project level (no -g) unless I say "globally".
- Prefer official sources and skills with 1K+ installs. Never install a skill I didn't approve.
<!-- skill-scout:end -->
EOF
fi

echo ""
echo "Done. Restart Claude Code, open any project, and type:"
echo "   find skills for this project"
echo ""
