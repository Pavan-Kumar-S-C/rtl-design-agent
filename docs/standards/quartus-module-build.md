# Quartus module build — agent standard (Standard Edition)

**Invoke routing:** synthesis / project QSF → `@rtl-design` · module `.sdc` → `@sdc` · fit / STA / timing reports → `@timing-analysis`

**Scope:** **1–2 RTL modules** (agent-written or existing), not full-chip integration. **Quartus Prime Standard Edition** (`.qip` for IP).

## Use the workspace as-is (no default sandbox)

**Do not** create `quartus/module_build/<module>/` or relocate RTL unless the user **explicitly** asks for a new Quartus project.

| Source of truth | Use |
|-----------------|-----|
| RTL file location | Wherever the module already lives in the workspace (`rtl/`, `docs/presentation/`, etc.) |
| Quartus project | Existing `.qpf` / `.qsf` in the workspace — detect or ask which project |
| Tool environment | User’s shell with **qshell** entered, or `quartus_*` already on **PATH** |
| Reports | Project `output_files/` (or path from `.qsf` `PROJECT_OUTPUT_DIRECTORY`) |

**Typical flow:** User opens their **FPGA project** in Cursor, has entered **qshell** (or Quartus `bin64` on PATH). User asks to run synthesis → agent `cd`s to the directory with the `.qpf`, runs `quartus_map` / `quartus_sh` for the named project — **no** copied RTL, **no** agent-generated tree.

**Agent package repo** (`rtl-design-agent` only): often no Quartus and no `.qpf` — **stop** and say compile must run from the user’s FPGA workspace with qshell/PATH; do not invent a sandbox here.

## Tool availability

1. If `quartus_map`, `quartus_sh`, or `quartus_sta` resolve on **PATH** (qshell) — use them directly in the project directory.
2. Else resolve via `QUARTUS_ROOT` or `rtl_db/index.yaml` `implementation.quartus_bin` ([resolve-quartus.ps1](../../../scripts/quartus/resolve-quartus.ps1)).
3. If still not found — **stop**; do not pretend compile succeeded.

## Opt-in only (mandatory)

**Do not run any Quartus step unless the user explicitly asks** for that step.

| User did | Agent must |
|----------|------------|
| Write/generate RTL only | Deliver RTL. **Stop.** No Quartus commands. |
| **Run synthesis** / **compile** | Run **synthesis only** against the workspace `.qpf` (or ask which project). |
| **Run fit** | Run fitter only if asked. |
| **Run STA** / review timing | STA and/or read `.rpt` via `@timing-analysis`. |
| **Write module SDC** | `@sdc` only. |
| **Create Quartus project** | Only then add/update `.qpf`/`.qsf` — in place in the workspace, not a mandatory `module_build/` layout. |

**Never:** chain synthesis → fit → STA after RTL is done; run Quartus because RTL exists; copy RTL into a new tree without user request.

## Prerequisites (ask before first compile)

When the user requests a compile step and info is missing, ask in **one batch**:

1. **Which `.qpf`** (or project directory) — search workspace if not stated
2. **Device family / part** — read from `.qsf` `DEVICE` if present; else ask (do not invent)
3. **Top entity** for the module under test — read from `.qsf` or RTL; confirm if ambiguous
4. **RTL in project** — if the module file is not in `.qsf`, ask before adding `VERILOG_FILE` assignments

Optional in `rtl_db/index.yaml`:

```yaml
implementation:
  quartus_edition: standard
  quartus_project: "path/to/design.qpf"   # optional hint
  quartus_bin: ""                          # only if not using qshell/PATH
  device_family: "TBD"
  device_part: "TBD"
```

## Running commands (Standard Edition)

From the directory containing `<project>.qpf` (qshell or PATH active):

| User asked | Command (project basename = `.qpf` name without extension) |
|------------|--------------------------------------------------------------|
| Synthesis only | `quartus_map --read_settings_files=on --write_settings_files=off <project>` |
| Fit only | `quartus_fit --read_settings_files=on --write_settings_files=off <project>` |
| STA only | `quartus_sta <project>` |
| Full compile | `quartus_sh --flow compile <project>` |

Optional wrapper: [scripts/quartus/module-build.ps1](../../../scripts/quartus/module-build.ps1) `-ProjectDir <dir-with-qpf>` `-Phase synth|fit|sta|full`.

After run, read reports under that project’s output directory (e.g. `output_files/*.map.rpt`). **Do not** run the next phase unless the user asked.

## Step ownership

| Step | Skill |
|------|--------|
| Run synthesis, triage synthesis `.rpt`, add RTL to `.qsf` if user asked | `@rtl-design` |
| Module `.sdc` | `@sdc` |
| Fit, STA, timing `.rpt` | `@timing-analysis` |

## Related invokes

| Task | Invoke |
|------|--------|
| RTL, synthesis, `.qsf` updates | `@rtl-design` |
| `.sdc` | `@sdc` |
| Fit, STA, timing reports | `@timing-analysis` |
| Sim (optional) | `@testbench` |
