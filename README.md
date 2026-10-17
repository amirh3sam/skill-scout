# skill-scout

**One command. Claude Code finds the right skills for every project.**

Install once on your computer. After that, open any project in Claude Code and just say what you're building. Claude searches 500K+ community skills, shows you the best matches, and installs the one you pick.

```
find skills for this project
```

No hunting through GitHub. No copying folders. No guessing which repo is legit.

---

## Install

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/amirh3sam/skill-scout/main/install.ps1 | iex
```

**Mac / Linux**

```bash
curl -fsSL https://raw.githubusercontent.com/amirh3sam/skill-scout/main/install.sh | bash
```

Then **restart Claude Code**. That's it.

> You need [Claude Code](https://claude.com/claude-code) and [Node.js](https://nodejs.org) (LTS).
>
> **Windows tip:** run it in PowerShell, not `bash`. Typing `bash` in PowerShell tries to start WSL and fails on most PCs.

---

## What it does

Three things, all global (every project on your computer):

| Step | What | Where |
| ---- | ---- | ----- |
| 1 | Installs **find-skills** by Vercel Labs, the most-installed skill on [skills.sh](https://skills.sh) | `~/.claude/skills/find-skills` |
| 2 | Lets Claude run `npx skills` commands without asking every time | `~/.claude/settings.json` |
| 3 | Adds a rule so Claude **checks for skills before new tasks** and asks before installing | `~/.claude/CLAUDE.md` |

It doesn't touch anything else in your setup.

---

## How you use it

1. Open any project and start `claude`.
2. Say what you need, or just: `find skills for this project`
3. Claude shows the top matches with install counts and source.
4. You pick, e.g. "install 1 and 3".
5. Restart Claude Code so the new skills load.

Skills install **into that project** (`.claude/skills/`), so they're saved with your repo. Want one everywhere? Say "install it globally".

Claude also checks on its own when you start something new, like "add Stripe payments" or "write e2e tests", and asks before installing anything.

---

## Safety

- **You approve every install.** The rule tells Claude to show options and wait.
- It prefers official sources and skills with 1K+ installs.
- Step 2 auto-allows **only** `npx skills ...` commands. Nothing else.
- Skills run with Claude's permissions, so glance at a skill's repo before installing anything with low stars.

---

## Uninstall

Removes all three changes, and leaves the rest of your CLAUDE.md and settings alone.

**Windows**
```powershell
irm https://raw.githubusercontent.com/amirh3sam/skill-scout/main/uninstall.ps1 | iex
```

**Mac / Linux**
```bash
curl -fsSL https://raw.githubusercontent.com/amirh3sam/skill-scout/main/uninstall.sh | bash
```

---

## Credits

The skill search itself is **[find-skills](https://github.com/vercel-labs/skills)** by **Vercel Labs**, all credit to them. skill-scout is the one-line setup around it: global install, permission, and the "check first" rule.

Pairs well with **[idea-council](https://github.com/amirh3sam/idea-council)**: check if your idea is worth building, then let skill-scout load the right skills to build it.

---

Made by **[AmirHesam Tech](https://amirhesamtech.com)** · TikTok **[@techwithamirh3sam](https://www.tiktok.com/@techwithamirh3sam)**

If this saved you time, give it a ⭐. It helps other people find it.
