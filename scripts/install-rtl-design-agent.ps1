<#
.SYNOPSIS
  Install @rtl-design and @rtl-coding-standards skills to user or project .cursor/skills.

.EXAMPLE
  .\scripts\install-rtl-design-agent.ps1
  .\scripts\install-rtl-design-agent.ps1 -LinkToProject
  .\scripts\install-rtl-design-agent.ps1 -Local
  .\scripts\install-rtl-design-agent.ps1 -Copy
#>
param(
    [string]$RepoUrl = "",
    [string]$Branch = "main",
    [switch]$LinkToProject,
    [switch]$Copy,
    [switch]$Local
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent
$SkillNames = @("rtl-design", "rtl-coding-standards")

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

$useLocal = $Local -or -not $RepoUrl -or ($RepoUrl -match 'YOURORG')
if ($useLocal) {
    Install-AllFromRoot $RepoRoot
    Write-Host ""
    Write-Host "Done (local repo). Skills: $($SkillNames -join ', '). Restart Cursor."
    exit 0
}

$cache = Join-Path $env:USERPROFILE ".cursor\rtl-design-agent-cache"
if (-not (Test-Path (Join-Path $cache ".git"))) {
    git clone --branch $Branch --single-branch $RepoUrl $cache
} else {
    git -C $cache fetch origin $Branch
    git -C $cache checkout $Branch
    git -C $cache pull origin $Branch
}

Install-AllFromRoot $cache
Write-Host ""
Write-Host "Done. Skills: $($SkillNames -join ', '). Restart Cursor. Re-run after git pull to refresh."
