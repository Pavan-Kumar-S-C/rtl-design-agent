<#
.SYNOPSIS
  Clone rtl-design-agent without docs/standards PDFs (~2 MB vs ~70 MB).

.EXAMPLE
  .\scripts\sparse-clone.ps1
  .\scripts\sparse-clone.ps1 -Destination C:\tools\rtl-design-agent
#>
param(
    [string]$Destination = "rtl-design-agent",
    [string]$RepoUrl = "",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot
$SlimList = Join-Path $ScriptDir "sparse-checkout-slim.list"

if (-not $RepoUrl) {
    foreach ($cfg in @(
            (Join-Path $ScriptDir "repo.config.local.json"),
            (Join-Path $ScriptDir "repo.config.example.json")
        )) {
        if (Test-Path $cfg) {
            $j = Get-Content $cfg -Raw | ConvertFrom-Json
            if ($j.repoUrl -and $j.repoUrl -notmatch 'YOURORG') { $RepoUrl = $j.repoUrl; break }
        }
    }
}
if (-not $RepoUrl) { $RepoUrl = $env:RTL_DESIGN_REPO }
if (-not $RepoUrl) { $RepoUrl = "https://github.com/Pavan-Kumar-S-C/rtl-design-agent.git" }

if (Test-Path $Destination) { throw "Destination already exists: $Destination" }

Write-Host "Sparse clone (no PDFs): $RepoUrl -> $Destination"
git clone --filter=blob:none --sparse --branch $Branch --single-branch $RepoUrl $Destination
git -C $Destination sparse-checkout init --no-cone
Get-Content $SlimList | git -C $Destination sparse-checkout set --stdin

$pdfCount = (Get-ChildItem -Path (Join-Path $Destination "docs\standards") -Filter *.pdf -ErrorAction SilentlyContinue).Count
$mb = [math]::Round((Get-ChildItem $Destination -Recurse -File | Measure-Object Length -Sum).Sum / 1MB, 1)
Write-Host "Done. PDFs on disk: $pdfCount. Working tree ~${mb} MB."
Write-Host "Install skills: cd $Destination; .\scripts\install-rtl-design-agent.ps1 -Local"
