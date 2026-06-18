# VC SpyGlass CDC — FPGA index

**Invoke:** `@cdc` · **UG:** [VC_SpyGlass_CDC_UserGuide.pdf](VC_SpyGlass_CDC_UserGuide.pdf) (X-2025.06) · **Extract:** [_spyglass_cdc_extract_raw.txt](_spyglass_cdc_extract_raw.txt)

**Not** RTL CDC coding — `@rtl-design` + [cdc-crossings.md](cdc-crossings.md). **Not** SDC authoring — `@sdc`.

## Goal files (load one per task)

| Goal | File | Command |
|------|------|---------|
| `cdc_setup` (+ `cdc_setup_check`) | [spyglass-cdc/cdc_setup.md](spyglass-cdc/cdc_setup.md) | `check_cdc -type setup` |
| `cdc_reset_integrity` | [spyglass-cdc/cdc_reset_integrity.md](spyglass-cdc/cdc_reset_integrity.md) | `check_cdc -type sync` (reset tags) |
| `cdc_verify` | [spyglass-cdc/cdc_verify.md](spyglass-cdc/cdc_verify.md) | `check_cdc -type integ` (opt), `check_cdc -type sync` |
| `cdc_verify_struct` | [spyglass-cdc/cdc_verify_struct.md](spyglass-cdc/cdc_verify_struct.md) | `check_cdc -type struct` |
| `cdc_abstract` | [spyglass-cdc/cdc_abstract.md](spyglass-cdc/cdc_abstract.md) | SAM flow |

**Out of scope:** RDC-only flows, goals not listed above.

## FPGA prerequisites (all goals)

- `set_app_var enable_cdc true`
- `read_sdc` with **verified** clocks/resets (not `infer_setup` alone for sign-off)
- Licenses: VC-LINT-BASE, VC-CDC-BASE
- Clean **setup** before sync / struct / abstract

## Recommended flow

```text
read_sdc → check_cdc -type setup     → cdc_setup.md
         → check_cdc -type sync       → cdc_verify.md + cdc_reset_integrity.md
         → check_cdc -type struct     → cdc_verify_struct.md
Block:    create_cdc_abstract_model    → cdc_abstract.md
SoC:      set_abstract_model (pre-elab) → configure_cdc_validation → check_cdc
```

## Minimal shell reference

```tcl
set_app_var enable_cdc true
analyze -f sverilog {design.sv}
elaborate TOP
read_sdc design.sdc
check_cdc -type setup
check_cdc -type sync
check_cdc -type struct
report_violations -app CDC
view_activity
```

## PDF opt-in

Load [VC_SpyGlass_CDC_UserGuide.pdf](VC_SpyGlass_CDC_UserGuide.pdf) only when user needs verbatim per-tag debug text not in goal files.
