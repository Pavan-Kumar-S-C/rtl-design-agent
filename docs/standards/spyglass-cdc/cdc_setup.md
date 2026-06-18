# SpyGlass CDC — `cdc_setup` (+ `cdc_setup_check`)

**Invoke:** `@cdc` · **UG:** Ch. 3 — Creating and Verifying CDC Setup · **PDF:** [VC_SpyGlass_CDC_UserGuide.pdf](../VC_SpyGlass_CDC_UserGuide.pdf)

**Related:** SDC authoring → `@sdc` · RTL synchronizers → `@rtl-design`

## Purpose

Create and verify CDC setup **before** any crossing analysis. Setup quality dictates verification quality — wrong or incomplete constraints cause false violations or missed real bugs.

`cdc_setup_check` is the **debug phase** of the same `check_cdc -type setup` run: resolve `SETUP_*` tags until setup is clean.

## Prerequisites

- `set_app_var enable_cdc true`
- Design read complete (`analyze` / `elaborate`)
- Licenses: VC-CDC-BASE (Elite/Apex per UG)

## Commands

### Create constraints

Define in SDC (read via `read_sdc`):

| Constraint | Command |
|------------|---------|
| Primary clocks | `create_clock` |
| Generated clocks | `create_generated_clock` |
| Resets | `create_reset` |
| Constants | `set_case_analysis` |
| Quasi-static | `create_static` / `create_quasi` |
| Clock relationships | `set_clock_groups` |
| Top-level port paths | `set_input_delay`, `set_output_delay`, `set_clock_attribute`, `set_sync_attribute` |
| Combo path association | `set_connectivity_attribute` |

UG note: CDC reads the same Tcl/SDC as Design Compiler / PrimeTime — **do not strip** Tcl from Quartus/Intel STA or synthesis constraint files.

### Verify setup

```tcl
read_sdc design.sdc
check_cdc -type setup
report_violations -app CDC
```

Setup also generates `auto_case_analysis.sdc` under `vcst_rtdb/.internal/cdc/` — review and uncomment valid `set_case_analysis` for mux-select / clock-enable on clock paths.

### Clock inventory

```tcl
get_clocks
report_clock
get_attribute [get_clocks] period
```

## FPGA sign-off rules

- **Reuse verified Quartus/Intel SDC** — do not sign off on `infer_setup` alone.
- `infer_setup -type clock | reset` — preliminary only when SDC missing; manually review `set_clock_groups` relationships.
- `write_inferred_setup -file <name> -type clock|reset` — replace with verified constraints when STA SDC is available.
- Optional proc `use_inferred_clocks` (source `cdc.tcl`) — incremental infer + `read_sdc -inferred`; still requires manual review.
- `set_app_var clock_source_sequential_propagation false` — stop clock propagation through sequential elements when needed.

## `cdc_setup_check` — debug workflow

1. Run `check_cdc -type setup`
2. For each `SETUP_*` tag: schematic + backtrace (View Activity / GUI)
3. Fix SDC or RTL driving constants / black-boxes blocking propagation
4. Re-run until clean before `sync` / `struct`

### Key `configure_cdc_setup_check` options

| Option | Use |
|--------|-----|
| `-show_constant_source true` | Reason codes `RTL_CONSTANT`, `SCA_CONSTANT`, `RTL_SCA_CONSTANT` on constant clock/data |
| `-report_all_setup_data_constant_violation true` | All `SETUP_DATA_CONSTANT` on set/reset pins |
| `-check_port_setup all` | Report output ports (default: input only) for port constraint tags |

Related configure: `configure_unconstrained_ports`, `configure_setup_port`, `configure_cdc_setup_blackbox`, `configure_cdc_tag`.

## `SETUP_*` tags (FPGA — fix errors before verify)

### Errors (must fix)

| Tag | Description | Debug / fix |
|-----|-------------|-------------|
| `SETUP_CLKPROP_NO_CLK` | No clock definitions in SDC for propagated clock | Add `create_clock` / `create_generated_clock` |
| `SETUP_CLOCK_CONSTANT` | Clock pin tied to constant | Backtrace clock pin; fix `set_case_analysis` or RTL — **flops excluded from CDC** |
| `SETUP_PORT_PARTIALLY_CONSTRAINED` | Top port partially constrained | Complete port constraints |
| `SETUP_CLOCKPATH_MUX_NOCLOCK` | Mux in clock path missing clock on a data input | Constrain all mux inputs or fix clock tree |
| `SETUP_CLOCK_GLITCH` | Async source converges with clock in different domain | See also [cdc_verify_struct.md](cdc_verify_struct.md) |

### Warnings / info (review)

| Tag | Severity | Description | Reason codes (typical) |
|-----|----------|-------------|----------------------|
| `SETUP_DATA_CONSTANT` | Info | Data pin constant — flop may be excluded from CDC | `CONST_DATA`, `CONST_DATA_SET`, `CONST_DATA_RESET` |
| `SETUP_ASYNC_CLOCK_OVERLAP_CONSTRAINED` | Info | Async clocks converge but constrained at gate | `MUX_SELPIN_CONSTRAINED`, `MUX_OUTPUT_CLOCK`, `COMBO_OUTPUT_CLOCK` |
| `SETUP_ASYNC_CLOCK_OVERWRITE` | Warning | User clock overwrites async-related clock in fanout | Review clock intent |
| `SETUP_SYNC_CLOCK_OVERLAP` | Info | Sync clocks converge on combo gate | Review if overwrite clock should propagate |
| `SETUP_SYNC_CLOCK_OVERLAP_CONSTRAINED` | Info | Sync overlap with mux select / combo output constrained | Example: `set_case_analysis` on mux sel |
| `SETUP_CLOCK_RESET_TREE` | Info | Clock/reset tree browser DB generated | Informational |
| `SETUP_PORT_*` (unconstrained / fully constrained) | varies | Port clock association | `PORT_UNCLOCKED_SEQS`, `PORT_UNCONNECTED`, `PORT_NO_SEQS` |

### Port constraint definition (UG)

A top-level port is **fully constrained** when any of: `create_clock`, `set_input_delay`, `set_output_delay`, `set_case_analysis`, `create_static`, `set_clock_attribute`, `set_sync_attribute` apply. For **inout** data paths, constrain both directions.

## Common setup reason codes

| Code | Meaning |
|------|---------|
| `MULT_ASYNC_CLK_MUX` | Multiple async clocks through mux |
| `MULT_ASYNC_CLKGATE` | Multiple async clocks through clock gate |
| `MUX_DRIVING_REDUNDANT_LOGIC` | Mux drives redundant clock logic |
| `COMBO_DRIVING_REDUNDANT_LOGIC` | Combo drives redundant clock logic |
| `PORT_UNCLOCKED_SEQS` | Sequential logic on port without clock association |
| `RTL_CONSTANT` / `SCA_CONSTANT` | Constant source on clock/data |

## Minimal Tcl example

```tcl
set_app_var enable_cdc true
analyze -f sverilog {top.sv}
elaborate TOP
read_sdc top.sdc
configure_cdc_setup_check -check_port_setup all
check_cdc -type setup
report_violations -app CDC -file setup.rpt
```

## PDF opt-in

Per-tag verbatim text: UG Ch. 3 — Debugging CDC Setup Violations. Partial extract: [_spyglass_cdc_extract_raw.txt](../_spyglass_cdc_extract_raw.txt) sections `CDC_SETUP`, `CDC_SETUP_CHECK`.
