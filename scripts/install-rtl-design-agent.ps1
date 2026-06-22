<#
.SYNOPSIS
  Install @rtl-design, @rtl-coding-standards, @timing-analysis, @sdc, @cdc, @lint, @testbench, and @help skills to user or project .cursor/skills.

.EXAMPLE
  .\scripts\install-rtl-design-agent.ps1
  .\scripts\install-rtl-design-agent.ps1 -LinkToProject
  .\scripts\install-rtl-design-agent.ps1 -Local
  .\scripts\install-rtl-design-agent.ps1 -Copy
  .\scripts\install-rtl-design-agent.ps1 -IncludePdfDocs   # full ~70 MB docs cache
#>
param(
    [string]$RepoUrl = "",
    [string]$Branch = "main",
    [switch]$LinkToProject,
    [switch]$Copy,
    [switch]$Local,
    [switch]$IncludePdfDocs
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent
$SkillNames = @("rtl-design", "rtl-coding-standards", "timing-analysis", "sdc", "cdc", "lint", "testbench", "help")

function Get-ConfigRepoUrl {
    foreach ($cfg in @(
            (Join-Path $ScriptDir "repo.config.local.json"),
            (Join-Path $ScriptDir "repo.config.example.json")
        )) {
        if (Test-Path $cfg) {
            $j = Get-Content $cfg -Raw | ConvertFrom-Json
            if ($j.repoUrl -and $j.repoUrl -notmatch 'YOURORG') { return $j.repoUrl }
        }
    }
    return ""
}

if (-not $RepoUrl) { $RepoUrl = $env:RTL_DESIGN_REPO }
if (-not $RepoUrl) { $RepoUrl = Get-ConfigRepoUrl }

if ($LinkToProject) {
    $SkillsDest = Join-Path (Get-Location) ".cursor\skills"
} else {
    $SkillsDest = Join-Path $env:USERPROFILE ".cursor\skills"
}
New-Item -ItemType Directory -Force -Path $SkillsDest | Out-Null

function Install-Skill([string]$Name, [string]$Src) {
    $dest = Join-Path $SkillsDest $Name
    if (-not (Test-Path $Src)) { throw "Missing skill source: $Src" }
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    if ($Copy) {
        Copy-Item -Recurse $Src $dest
        Write-Host "Copied $Name -> $dest"
    } else {
        cmd /c mklink /J "`"$dest`"" "`"$Src`"" 2>$null | Out-Null
        if (-not (Test-Path $dest)) {
            Copy-Item -Recurse $Src $dest
            Write-Host "Copied $Name (junction failed) -> $dest"
        } else {
            Write-Host "Linked $Name -> $Src"
        }
    }
}

function Install-AllFromRoot([string]$Root) {
    foreach ($name in $SkillNames) {
        Install-Skill $name (Join-Path $Root ".cursor\skills\$name")
    }
}

function Set-SlimSparseCheckout([string]$RepoPath) {
    $slimList = Join-Path $ScriptDir "sparse-checkout-slim.list"
    if (-not (Test-Path $slimList)) { return }
    git -C $RepoPath sparse-checkout init --no-cone 2>$null
    Get-Content $slimList | git -C $RepoPath sparse-checkout set --stdin
}

$useLocal = $Local -or -not $RepoUrl -or ($RepoUrl -match 'YOURORG')
if ($useLocal) {
    Install-AllFromRoot $RepoRoot
    Write-Host ""
    Write-Host "Done (local repo). Skills: $($SkillNames -join ', '). Restart Cursor."
    exit 0
}

$cache = Join-Path $env:USERPROFILE ".cursor\rtl-design-agent-cache"
if (-not (Test-Path (Join-Path $cache ".git"))) {
    if ($IncludePdfDocs) {
        git clone --branch $Branch --single-branch $RepoUrl $cache
    } else {
        git clone --filter=blob:none --sparse --branch $Branch --single-branch $RepoUrl $cache
        Set-SlimSparseCheckout $cache
        Write-Host "Slim cache clone (no PDFs). Use -IncludePdfDocs for full docs."
    }
} else {
    git -C $cache fetch origin $Branch
    git -C $cache checkout $Branch
    git -C $cache pull origin $Branch
}

Install-AllFromRoot $cache
Write-Host ""
Write-Host "Done. Skills: $($SkillNames -join ', '). Restart Cursor. Re-run after git pull to refresh."
