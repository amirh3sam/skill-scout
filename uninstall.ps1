# skill-scout uninstaller for Windows (PowerShell)
# Run:  irm https://raw.githubusercontent.com/amirh3sam/skill-scout/main/uninstall.ps1 | iex

& {
    $dir = Join-Path $HOME ".claude"

    # 1. Remove the find-skills skill
    $skill = Join-Path $dir "skills\find-skills"
    if (Test-Path $skill) { Remove-Item -Recurse -Force $skill }

    # 2. Remove the permission rule
    $f = Join-Path $dir "settings.json"
    if (Test-Path $f) {
        $raw = Get-Content $f -Raw
        if ($raw) {
            $s = $raw | ConvertFrom-Json
            if ($s.PSObject.Properties['permissions'] -and $s.permissions.PSObject.Properties['allow']) {
                $s.permissions.allow = @($s.permissions.allow | Where-Object { $_ -ne 'Bash(npx skills:*)' })
                [IO.File]::WriteAllText($f, ($s | ConvertTo-Json -Depth 20))
            }
        }
    }

    # 3. Remove the skill-scout block from CLAUDE.md
    $md = Join-Path $dir "CLAUDE.md"
    if (Test-Path $md) {
        $text = Get-Content $md -Raw
        $clean = [regex]::Replace($text, '\r?\n?<!-- skill-scout:start -->[\s\S]*?<!-- skill-scout:end -->\r?\n?', '')
        [IO.File]::WriteAllText($md, $clean)
    }

    Write-Host "skill-scout removed. Restart Claude Code." -ForegroundColor Green
}
