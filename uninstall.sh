#!/usr/bin/env bash
# skill-scout uninstaller for Mac / Linux
# Run:  curl -fsSL https://raw.githubusercontent.com/amirh3sam/skill-scout/main/uninstall.sh | bash
set -e
DIR="$HOME/.claude"

rm -rf "$DIR/skills/find-skills"

if [ -f "$DIR/settings.json" ] && command -v node >/dev/null 2>&1; then
  node -e '
const fs = require("fs");
const p = process.argv[1];
const t = fs.readFileSync(p, "utf8").trim();
if (t) {
  const s = JSON.parse(t);
  if (s.permissions && Array.isArray(s.permissions.allow)) {
    s.permissions.allow = s.permissions.allow.filter(r => r !== "Bash(npx skills:*)");
    fs.writeFileSync(p, JSON.stringify(s, null, 2));
  }
}
' "$DIR/settings.json"
fi

if [ -f "$DIR/CLAUDE.md" ]; then
  node -e '
const fs = require("fs");
const p = process.argv[1];
const t = fs.readFileSync(p, "utf8");
fs.writeFileSync(p, t.replace(/\r?\n?<!-- skill-scout:start -->[\s\S]*?<!-- skill-scout:end -->\r?\n?/, ""));
' "$DIR/CLAUDE.md"
fi

echo "skill-scout removed. Restart Claude Code."
