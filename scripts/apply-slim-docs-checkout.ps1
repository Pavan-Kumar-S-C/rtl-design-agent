<#
.SYNOPSIS
  Apply slim sparse-checkout to current repo (drop PDFs from working tree).

.EXAMPLE
  cd rtl-design-agent
  .\scripts\apply-slim-docs-checkout.ps1
#>
$ErrorActionPreference = "Stop"
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$SlimList = Join-Path $PSScriptRoot "sparse-checkout-slim.list"

Set-Location $RepoRoot
git sparse-checkout init --no-cone
Get-Content $SlimList | git sparse-checkout set --stdin

$pdfCount = (Get-ChildItem docs\standards\*.pdf -ErrorAction SilentlyContinue).Count
Write-Host "Slim checkout applied. PDFs on disk: $pdfCount."
Write-Host "To restore PDFs later: git sparse-checkout add docs/standards/*.pdf"
