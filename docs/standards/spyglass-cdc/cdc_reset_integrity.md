# SpyGlass CDC — `cdc_reset_integrity`

**Invoke:** `@cdc` · **UG:** Ch. 6 — VC SpyGlass CDC Unsynchronized Reset Checks · **PDF:** [VC_SpyGlass_CDC_UserGuide.pdf](../VC_SpyGlass_CDC_UserGuide.pdf)

**Related:** Reset RTL patterns → `@rtl-design` + [clocks-resets.md](../clocks-resets.md) · SDC `create_reset` → `@sdc`

## Purpose

Verify that **asynchronous reset / preset / clear** paths crossing clock domains are **structurally synchronized** before reaching destination sequential elements. Unsynchronized reset de-assertion can cause **reset recovery** violations and metastability (same class of risk as data CDC).

Runs as part of **`check_cdc -type sync`** after clean setup — reset verification is **enabled by default**.

## Prerequisites

- Clean `check_cdc -type setup` (clocks, resets, ports declared)
- `set_app_var enable_cdc true`
- `create_reset` constraints for sign-off (do not rely on inferred resets alone)

## Commands

```tcl
# Default — reset checks run with sync
check_cdc -type sync

# Optional: run reset checks without complete reset setup (preliminary only)
set_app_var enable_resetless_analysis true
check_cdc -type sync
```

Reset tree debug:

```tcl
write_reset_tree
get_asyncrst_paths
get_reset_roots
```

## Metastability / recovery (UG)

When async reset `RST1` de-asserts in domain C2 but affects a flop clocked by C1, de-assertion can land near a C1 edge → **reset recovery** / metastability if sync is missing or incorrect.

All data-path CDC issues (convergence, blocking gates, NFF depth) apply to **reset path crossings**.

## Key tags

| Tag | Severity | Description |
|-----|----------|-------------|
| `CDC_UNSYNC_ASYNCRESET` | **Error** | No valid synchronization on async reset crossing |
| `CDC_SYNC_ASYNCRESET` | Info | Valid reset synchronizer detected |
| `CDC_ASYNCRESET_CTRLSYNC_INVALID_USE` | Error/Warning | Invalid control-sync use on reset path |
| `CDC_COHERENCY_ASYNCRESET` | varies | Reset coherency violation |
| `CDC_IGNOREPATH_USER_CONSTRAINT_ASYNCRESET` | Info | Waived by user constraint |
| `CDC_IGNOREPATH_QUASI_STATIC_ASYNCRESET` | Info | Quasi-static waiver on reset path |
| `CDC_IGNOREPATH_FALSEPATH_ASYNCRESET` | Info | False-path waiver |
| `CDC_FILTERED_USER_CONSTRAINT_ASYNCRESET` | Info | Filtered by user constraint |
| `CDCSYNC_ASYNCRST_IGNOREPATH_CONST_SRC` | Info | Constant source on reset path ignored |

## `CDC_UNSYNC_ASYNCRESET` reason codes

| Reason code | Meaning |
|-------------|---------|
| `NO_SYNC_METHOD` | No synchronizer at destination |
| `INVALID_BLOCKING_GATE` | AND/MUX gate cannot block all paths (e.g. converging reset before valid gate) |
| `UNSYNC_NONSTATIC_COMBO` | Non-static combo in reset crossing |
| `SRC_CONVERGES_ASYNC_SRC` | Multiple async sources converge |
| `ASYNC_SRC_CONVERGE` | Async sources converge before destination |
| `QUAL_CONVERGES_OTHER_SYNC_SRC` | Qualifier merges with other sync source |
| `QUAL_CONVERGES_SAME_SRC` | Qualifier converges with same source incorrectly |
| `SRC_CONVERGES_QUAL_INSIDE_LOOP` | Qualifier inside loop with source convergence |
| `NFF_DST_WITH_MULTI_FANOUTS` | NFF output fans out before destination sync complete |
| `RST_ASYNC_DEASSERTION` | Async de-assertion timing risk |
| `NFF_HALF_SYNC` | Half-synchronized NFF chain |
| `VALID_CLOCK_PHASE_RELATION` / `CLOCK_PHASE_RELATION_NOT_SATISFIED` | Phase relationship for reset sync |
| `SRC_COUNT_EXCEEDS_USER_CONSTRAINT` | Too many sources per user limit |

## Violation message fields (debug)

`SrcObject`, `DestObject`, `SrcClockInfoList`, `DestClockInfoList`, `AllSrcResets`, `SrcConstrInfo`, file/line back-reference.

## FPGA fix patterns

1. **NFF reset synchronizer** — async assert, **sync de-assert** in destination clock domain (per company reset guidelines).
2. **No invalid blocking gates** — all paths from async reset source to destination preset/clear must pass through a valid gate with proper qualifier (UG Fig. 20–21).
3. **Library / UDS cells** — configure `configure_cdc_asyncrst_nff_sync`, `configure_cdc_back_to_back_uds`, `configure_cdc_asyncrst_data_sync` when using vendor synchronizer cells; see `CDC_SYNC_ASYNCRESET` supported schemes in UG.
4. **Do not waive** `CDC_UNSYNC_ASYNCRESET` without documented architectural justification.

## Configure commands

| Command | Use |
|---------|-----|
| `configure_cdc_asyncrst_crossing` | Reset crossing detection rules |
| `configure_cdc_asyncrst_nff_sync` | NFF reset synchronizer recognition |
| `configure_cdc_asyncrst_data_sync` | Data-style reset sync schemes |
| `configure_cdc_back_to_back_uds` | Back-to-back UDS reset cells |
| `configure_clock_reset_tree` | Reset tree analysis |
| `configure_clock_reset_race` | Clock/reset race checks |

## Tcl example

```tcl
read_sdc design.sdc   # must include create_reset
check_cdc -type setup
check_cdc -type sync
report_violations -app CDC -tag CDC_UNSYNC_ASYNCRESET
```

## PDF opt-in

UG Ch. 6 — Tags for Reset Synchronization Violations (pages ~497–501+). Extract section `CDC_RESET_INTEGRITY` has 0 pages — use PDF for full tag text.
