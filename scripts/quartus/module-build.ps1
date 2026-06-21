<#
.SYNOPSIS
  Run Quartus Standard compile phase in the directory that contains a .qpf.

.EXAMPLE
  cd C:\my_fpga_project
  .\path\to\rtl-design-agent\scripts\quartus\module-build.ps1 -ProjectDir . -Phase synth
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectDir,
    [ValidateSet("synth", "fit", "sta", "full")]
    [string]$Phase = "synth",
    [string]$QuartusBin = ""
)

$ErrorActionPreference = "Stop"
$ProjectDir = Resolve-Path $ProjectDir
$qpf = Get-ChildItem -Path $ProjectDir -Filter "*.qpf" | Select-Object -First 1
if (-not $qpf) { throw "No .qpf in $ProjectDir" }
$projBase = [System.IO.Path]::GetFileNameWithoutExtension($qpf.Name)

$resolveScript = Join-Path $PSScriptRoot "resolve-quartus.ps1"
$bin64 = & $resolveScript -QuartusBin $QuartusBin
$env:PATH = "$bin64;$env:PATH"

Push-Location $ProjectDir
try {
    switch ($Phase) {
        "synth" {
            # Analysis & Synthesis only (Standard Edition)
            & quartus_map.exe --read_settings_files=on --write_settings_files=off $projBase
            if ($LASTEXITCODE -ne 0) { throw "quartus_map failed (exit $LASTEXITCODE)" }
        }
        "fit" {
            & quartus_fit.exe --read_settings_files=on --write_settings_files=off $projBase
            if ($LASTEXITCODE -ne 0) { throw "quartus_fit failed (exit $LASTEXITCODE)" }
        }
        "sta" {
            & quartus_sta.exe $projBase
            if ($LASTEXITCODE -ne 0) { throw "quartus_sta failed (exit $LASTEXITCODE)" }
        }
        "full" {
            & quartus_sh.exe --flow compile $projBase
            if ($LASTEXITCODE -ne 0) { throw "quartus_sh compile failed (exit $LASTEXITCODE)" }
        }
    }
    Write-Host "OK: $Phase completed for $projBase in $ProjectDir"
} finally {
    Pop-Location
}
