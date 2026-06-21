# Resolve Quartus bin64 directory for module-build.ps1
# Order: -QuartusBin param > $env:QUARTUS_ROOT > quartus_sh on PATH > rtl_db/index.yaml implementation.quartus_bin

param(
    [string]$QuartusBin = "",
    [string]$RtlDbIndex = ""
)

function Test-QuartusBin([string]$BinDir) {
    if (-not $BinDir) { return $null }
    $exe = Join-Path $BinDir "quartus_sh.exe"
    if (Test-Path $exe) { return (Resolve-Path $BinDir).Path }
    return $null
}

if ($QuartusBin) {
    $found = Test-QuartusBin $QuartusBin
    if ($found) { return $found }
    throw "quartus_sh.exe not found in: $QuartusBin"
}

if ($env:QUARTUS_ROOT) {
    $found = Test-QuartusBin (Join-Path $env:QUARTUS_ROOT "quartus\bin64")
    if ($found) { return $found }
}

$onPath = Get-Command quartus_sh.exe -ErrorAction SilentlyContinue
if ($onPath) { return (Split-Path $onPath.Source -Parent) }

$mapOnPath = Get-Command quartus_map.exe -ErrorAction SilentlyContinue
if ($mapOnPath) { return (Split-Path $mapOnPath.Source -Parent) }

if (-not $RtlDbIndex) {
    $candidates = @("rtl_db/index.yaml", "rtl_db\index.yaml")
    foreach ($c in $candidates) {
        if (Test-Path $c) { $RtlDbIndex = $c; break }
    }
}

if ($RtlDbIndex -and (Test-Path $RtlDbIndex)) {
    $raw = Get-Content $RtlDbIndex -Raw
    if ($raw -match '(?m)^\s*quartus_bin:\s*["'']?([^"''#\s]+)') {
        $found = Test-QuartusBin $Matches[1].Trim('"', "'")
        if ($found) { return $found }
    }
}

throw @"
Quartus not found. Enter qshell in your FPGA project terminal, or:
  - Add quartus\bin64 to PATH, or
  - Set QUARTUS_ROOT to the Intel FPGA install root, or
  - Set implementation.quartus_bin in rtl_db/index.yaml

Run compile from your FPGA RTL workspace (existing .qpf), not from the agent package repo alone.
"@
