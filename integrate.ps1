# Integrate this harness into the repository you are standing in.
# Run from the target repository root:  powershell -File C:\path\to\harness-loop\integrate.ps1
# Shared files are overwritten (update the harness); tasks/, backlog/ notes and config.json are never touched.
$ErrorActionPreference = "Stop"
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$dest = Join-Path (Get-Location) ".harness-loop"

foreach ($dir in @("", "tasks", "archived-tasks", "backlog", "task-assets")) {
    New-Item -ItemType Directory -Force -Path (Join-Path $dest $dir) | Out-Null
}
foreach ($file in @("runner.py", "selftest.py", "rules.md", ".gitignore", "config.example.json", "README.md", "backlog\sample-task.md")) {
    Copy-Item -Force (Join-Path $src $file) (Join-Path $dest $file)
    Write-Host "  updated .harness-loop\$file"
}
# task-assets: seed the folder and its ignore rules only when missing; never overwrite
foreach ($file in @("task-assets\.gitignore", "task-assets\.gitkeep")) {
    if (-not (Test-Path (Join-Path $dest $file))) {
        Copy-Item (Join-Path $src $file) (Join-Path $dest $file)
        Write-Host "  seeded .harness-loop\$file"
    }
}
if (-not (Test-Path (Join-Path $dest "config.json"))) {
    Copy-Item (Join-Path $src "config.example.json") (Join-Path $dest "config.json")
    Write-Host "  created .harness-loop\config.json from the example - fill in verify_commands, source_globs, test_globs"
} else {
    Write-Host "  kept existing .harness-loop\config.json"
}
Write-Host "`nNext: cd to this repo root, then"
Write-Host "  python .harness-loop\selftest.py"
Write-Host "  python .harness-loop\runner.py --dry-run"
