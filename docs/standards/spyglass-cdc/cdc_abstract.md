# SpyGlass CDC — `cdc_abstract` (SAM)

**Invoke:** `@cdc` · **UG:** Ch. 9 — Hierarchical Flow, SAM Based Hierarchical Flow · **PDF:** [VC_SpyGlass_CDC_UserGuide.pdf](../VC_SpyGlass_CDC_UserGuide.pdf)

**Related:** Block CDC sign-off → [cdc_verify.md](cdc_verify.md) · SoC constraints → `@sdc`

## Purpose

Generate and consume **Sign-off Abstract Models (SAM)** for hierarchical CDC:

- **Block level:** Abstract verified CDC structure for handoff to SoC integration
- **SoC level:** Verify top-level crossings using block SAMs instead of re-elaborating full RTL

SAM contains **CDC-specific structure only** — not for Lint, RDC, or synthesis reuse.

## Prerequisites (block)

- Block-level `check_cdc` **clean** (all goals reviewed: setup, sync, struct)
- `set_app_var enable_cdc true`
- `set_app_var enable_abstraction true`

## Block-level flow

```tcl
set_app_var enable_cdc true
set_app_var enable_abstraction true

analyze -f sverilog {block.sv}
elaborate BLOCK_TOP
read_sdc block_cdc.sdc
source block_cdc_config.tcl    ;# configure_cdc_* as needed

check_cdc                        ;# full block sign-off
report_violations -app CDC
view_activity

configure_cdc_abstract_model     ;# BEFORE create — port/sync abstract options
create_cdc_abstract_model
write_abstract_model -path <sam_dir>
```

Optional persistence:

```tcl
save_session -session block_cdc_signoff
```

### `configure_cdc_abstract_model`

Specify before `create_cdc_abstract_model`:

- Abstract port clock/domain association
- Which sync structures to preserve in SAM
- Bus merging / hierarchy options (`configure_bus_merging`, `configure_cdc_sg_hier`)

Related: `configure_abstract_port`, `customize_cdc_abstract_model`, `configure_cdc_sam_constraints`.

## SoC-level flow

**Critical:** `set_abstract_model` must run **before** `elaborate`. If specified after elaboration, SAM is not linked — informational `COM_OPT015`.

```tcl
set_app_var enable_cdc true

# Link SAMs — before design read/elaborate
set_abstract_model -module BLK1 -path <sam_path1>
set_abstract_model -module BLK2 -instance u_blk2 -path <sam_path2>

analyze -f sverilog {soc_top.sv}
elaborate SOC_TOP
read_sdc soc_cdc.sdc
source soc_cdc_config.tcl

configure_cdc_validation         ;# SoC-level SAM validation rules
check_cdc
report_violations -app CDC
view_activity
```

### `configure_cdc_validation`

Controls how SoC run validates crossings against loaded SAMs (port domain consistency, sync boundary rules). Use with `configure_cdc_hiersoc_verification` for large SoCs.

## SAM consumption warnings

| Tag | Severity | Issue | Action |
|-----|----------|-------|--------|
| `ABSTRACT_MODEL_MODULE_BLACKBOX_SPECIFIED` | Warning | Module with SAM also `set_black_box` | Remove black-box on SAM modules |

## Commands reference

| Command | Role |
|---------|------|
| `create_cdc_abstract_model` | Build SAM in current session (after clean CDC) |
| `write_abstract_model -path <dir>` | Write SAM to disk |
| `set_abstract_model -module <mod> [-instance <inst>] -path <dir>` | Load SAM at SoC (pre-elaborate) |
| `configure_cdc_abstract_model` | Abstract generation options |
| `configure_cdc_validation` | SoC SAM validation |
| `compress_cdc` | Compress CDC DB (advanced) |
| `save_cdc_constraints` | Save CDC constraint state |

## FPGA / block reuse notes

- Typical FPGA project: one chip-top — SAM used when integrating **reusable IP blocks** with proven CDC sign-off.
- Regenerate SAM when block RTL or CDC constraints change.
- Keep SAM path versioned alongside IP release tag.
- Do not use SAM generated from `create_cdc_abstract_model` for non-CDC SpyGlass apps.

## Session restore example (UG)

```tcl
# Block run saved session
save_session -session SI

# Restore (path depends on -out_dir / vcst_rtdb)
vc_static_shell -restore -session my/vcst_rtdb
```

## Tcl snippet (UG block sign-off)

```tcl
set_app_var enable_cdc true
set_app_var enable_abstraction true
set_app_var search_path ...
set_app_var link_library ...

analyze ...
elaborate BLOCK
read_sdc <cdc_setup>.sdc
source <cdc_config>.tcl

check_cdc
report_violations -app CDC
view_activity

create_cdc_abstract_model
write_abstract_model -path <path>
```

## PDF opt-in

UG Ch. 9 (pages ~634–636+), Table 2–3 (hierarchical steps, SAM consumption tags). Extract section `CDC_ABSTRACT` has partial pages — use PDF for `configure_cdc_abstract_model` full option list.
