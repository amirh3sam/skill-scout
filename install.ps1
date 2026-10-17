# skill-scout installer for Windows (PowerShell)
# One-time, global setup so Claude Code finds and installs the right skills for any project.
# Run:  irm https://raw.githubusercontent.com/amirh3sam/skill-scout/main/install.ps1 | iex

& {
    $ErrorActionPreference = 'Stop'
    Write-Host ""
    Write-Host "skill-scout: global setup for Claude Code" -ForegroundColor Cyan
    Write-Host ""

    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "Node.js is missing. Install the LTS version from https://nodejs.org, reopen PowerShell, and run this again." -ForegroundColor Red
        return
    }

    # 1. Install Vercel's find-skills skill globally
    Write-Host "[1/3] Installing find-skills (by Vercel Labs) globally..."
    & npx.cmd -y skills add vercel-labs/skills --skill find-skills -g -a claude-code -y
    if ($LASTEXITCODE -ne 0) {
        Write-Host "find-skills install failed. Check your internet connection and try again." -ForegroundColor Red
        return
    }

    # 2. Allow 'npx skills' commands without a prompt every time
    Write-Host "[2/3] Allowing 'npx skills' commands in Claude Code..."
    $dir = Join-Path $HOME ".claude"
    New-Item -ItemType Directory -Force $dir | Out-Null
    $f = Join-Path $dir "settings.json"
    $raw = if (Test-Path $f) { Get-Content $f -Raw } else { $null }
    $s = if ($raw) { $raw | ConvertFrom-Json } else { [pscustomobject]@{} }
    if (-not $s.PSObject.Properties['permissions']) {
        $s | Add-Member -NotePropertyName permissions -NotePropertyValue ([pscustomobject]@{})
    }
    if (-not $s.permissions.PSObject.Properties['allow']) {
        $s.permissions | Add-Member -NotePropertyName allow -NotePropertyValue @()
    }
    $rule = 'Bash(npx skills:*)'
    if (@($s.permissions.allow) -notcontains $rule) {
        $s.permissions.allow = @($s.permissions.allow) + $rule
    }
    [IO.File]::WriteAllText($f, ($s | ConvertTo-Json -Depth 20))

    # 3. Add the skill-scout rule to the global CLAUDE.md
    Write-Host "[3/3] Adding the 'check for skills first' rule to your global CLAUDE.md..."
    $md = Join-Path $dir "CLAUDE.md"
    $block = @"

<!-- skill-scout:start -->
## Skills
- Before starting a new task, use the find-skills skill to check if a relevant skill exists.
- Show me the top options (name, what it does, install count, source) and wait for my pick before installing.
- Install at project level (no -g) unless I say "globally".
- Prefer official sources and skills with 1K+ installs. Never install a skill I didn't approve.
<!-- skill-scout:end -->
"@
    if (-not (Test-Path $md) -or -not (Select-String -Path $md -SimpleMatch 'skill-scout:start' -Quiet)) {
        Add-Content -Path $md -Value $block
    }

    Write-Host ""
    Write-Host "Done. Restart Claude Code, open any project, and type:" -ForegroundColor Green
    Write-Host "   find skills for this project" -ForegroundColor Green
    Write-Host ""
}
