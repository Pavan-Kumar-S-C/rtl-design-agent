<#
.SYNOPSIS
  Create GitHub repo and push rtl-design-agent (first-time maintainer).

.PREREQUISITE
  gh auth login

.EXAMPLE
  .\scripts\create-github-repo.ps1
  .\scripts\create-github-repo.ps1 -RepoName rtl-design-agent -Visibility private
  .\scripts\create-github-repo.ps1 -OrgName my-team -RepoName rtl-design-agent
#>
param(
    [string]$RepoName = "rtl-design-agent",
    [string]$OrgName = "",
    [ValidateSet("private", "public", "internal")]
    [string]$Visibility = "private"
)

$ErrorActionPreference = "Stop"
$gh = "C:\Program Files\GitHub CLI\gh.exe"
if (-not (Test-Path $gh)) { $gh = "gh" }

$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

& $gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Not logged into GitHub. Run: gh auth login"
    exit 1
}

if (-not (Test-Path (Join-Path $Root ".git"))) {
    git init
    git add -A
    git commit -m "Initial rtl-design-agent scaffold"
}

if (git remote get-url origin 2>$null) {
    Write-Host "Remote 'origin' already exists:"
    git remote -v
    $ans = Read-Host "Push to existing origin? [y/N]"
    if ($ans -notmatch '^[yY]') { exit 0 }
} else {
    $fullName = if ($OrgName) { "$OrgName/$RepoName" } else { $RepoName }
    Write-Host "Creating GitHub repo: $fullName ($Visibility)"
    & $gh repo create $fullName --$Visibility --source=. --remote=origin `
        --description "Company-wide Cursor Verilog/SystemVerilog RTL agent (@rtl-design)"
    if ($LASTEXITCODE -ne 0) { throw "gh repo create failed" }
}

$branch = git branch --show-current
if (-not $branch) {
    git checkout -b main
    $branch = "main"
}

Write-Host "Pushing $branch..."
git push -u origin $branch

$url = & $gh repo view --json url -q .url
Write-Host ""
Write-Host "Done."
Write-Host "  Repo: $url"
Write-Host ""
Write-Host "Update scripts/repo.config.local.json:"
Write-Host "  `"repoUrl`": `"$url.git`""
Write-Host ""
Write-Host "Designers:"
Write-Host "  git clone $url rtl-design-agent"
Write-Host "  bash scripts/install-rtl-design-agent.sh"
