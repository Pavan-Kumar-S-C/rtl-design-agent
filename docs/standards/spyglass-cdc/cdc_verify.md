# SpyGlass CDC — `cdc_verify`

**Invoke:** `@cdc` · **UG:** Ch. 4–5 — Integrity + Synchronization Checks · **PDF:** [VC_SpyGlass_CDC_UserGuide.pdf](../VC_SpyGlass_CDC_UserGuide.pdf)

**Related:** Synchronizer RTL → `@rtl-design` + [cdc-crossings.md](../cdc-crossings.md) · MTBF reports → `@timing-analysis`

## Purpose

Structural verification that **data and control** clock-domain crossings are synchronized (safe) or flagged as unsynchronized (unsafe). Optional **integrity** pass checks clock/reset glitches and hazards before sync analysis.

Reset-path crossings are covered here too — see [cdc_reset_integrity.md](cdc_reset_integrity.md) for reset-specific tags.

## Prerequisites

- **Clean setup** — `check_cdc -type setup` with no blocking `SETUP_*` errors
- UG recommends setup as a **distinct sign-off step** before first sync run on a new design

## Commands

```tcl
# Optional — clock/reset glitch, race, integrity hazards
check_cdc -type integ

# Primary — synchronizer detection (control + data + reset)
check_cdc -type sync

# All phases (setup + integ + sync + struct) — use only when flow is understood
check_cdc
```

Reports: `report_violations -app CDC`, `view_activity`, `get_cdc_paths`, `get_synchronizer_cells`.

## Crossing objects (UG terminology)

| Object | Definition |
|--------|------------|
| **Source** | Originating flop, sequential macro, or primary input |
| **Destination** | Terminating flop, macro, or primary output |
| **Qualifier / synchronizer** | Control signal synchronizing a data crossing (NFF, UDS, user-defined) |
| **Blocking gate** | AND/OR/MUX where qualifier blocks source until safe — all source→dest paths must pass through valid gate |

### Valid blocking gate criteria

- Valid qualifier propagates to gate
- Qualifier value can **block** transfer (MUX selects dest-domain data; AND=0 blocks; OR=1 blocks)
- **All** paths from source to destination pass through the gate

## Synchronization schemes recognized

### Control path (reason codes — synchronized)

| Code | Scheme |
|------|--------|
| `SYNC_BY_NFF` | Multi-flop synchronizer |
| `SYNC_BY_UDS` | User-defined synchronizer cell |
| `NFF_HALF_SYNC` | Half-sync NFF (review) |
| `STATIC_COMBO_IN_CROSSING` | Static combo in path |
| `UPF_INSTRUMENTED` | UPF-instrumented crossing |

### Control path — unsynchronized reason codes

`NFF_DST_WITH_MULTI_FANOUTS`, `NONSTATIC_COMBO_IN_CROSSING`, `ASYNC_SRC_CONVERGE`, `NFF_DST_SYNC_POLARITY_MISMATCH`, `NFF_WITH_POTENTIAL_SYNCRESET_GATE`, `NFF_WITH_INSUFFICIENT_DEPTH`, `NFF_SYNC_AND_DST_CLK_PERIOD_DIFF`, `NFF_SYNC_AND_DST_CLK_DOMAIN_DIFF`, `NFF_INVALID_SEQ_CELL`, `NFF_HALF_SYNC`, `SRC_COUNT_EXCEEDS_USER_CONSTRAINT`, …

### Data path (reason codes — synchronized)

| Code | Scheme |
|------|--------|
| `SYNC_AT_BLOCKING_GATE` | Qualifier on valid gate |
| `SYNC_AT_RECIRC_MUX` / `SYNC_AT_NON_RECIRC_MUX` | MUX recirculation / non-recirc |
| `SYNC_AT_AND_OR_RECIRC_MUX` | AND/OR MUX recirculation |
| `SYNC_AT_ENABLE_PIN` | Enable-based sync |
| `SYNC_AT_LIBCELL_CGC` / `SYNC_AT_AUTO_INFERRED_CGC` / `SYNC_AT_USER_CGC` | Clock gating cells |
| `USER_SRC_SYNC` / `USER_DES_SYNC` | User src/des sync points |
| `USER_QUALIFIER` / `NFF_USED_AS_QUALIFIER` | User or NFF qualifier |
| `FUNCTIONALLY_BLOCKED` | Functionally blocked by qualifier |
| `SYNC_INSIDE_SAM_BLOCK` | Sync inside abstract block |

### Data path — unsynchronized reason codes

`INVALID_BLOCKING_GATE`, `QUAL_CONVERGES_OTHER_SYNC_SRC`, `MUX_SELPIN_SRC`, `QUAL_ON_MUX_DATAPIN`, `NO_DSTDOM_SIGNAL_ON_MUX_DATAPINS`, `SRC_SAME_AS_QUAL_SRC`, `QUAL_CONVERGES_SAME_SRC`, `QUALIFIER_PROPAGATED_ACROSS_DEST`, `POTENTIAL_SYNCRST_QUALIFIER`, `QUAL_CONVERGES_ASYNC_SRC`, `FUNCTIONALLY_UNBLOCKED`, `CLOCK_PHASE_RELATION_NOT_SATISFIED`, …

### General unsynchronized

| Code | Meaning |
|------|---------|
| `NO_SYNC_METHOD` | No synchronizer at destination |
| `SRC_CONVERGES_ASYNC_SRC` | Multiple async domains converge on one destination |
| `CDC_UNSYNC_INTERNAL_CROSSING` | Crossing between two clock pins of same libcell |
| `CDC_CLOCK_TO_D_CROSSING` | Source is a clock node |

## Primary violation tags

| Tag | Severity | Meaning |
|-----|----------|---------|
| `CDC_UNSYNC_NOSCHEME` | **Error** | Unsynchronized crossing — no scheme |
| `CDC_UNSYNC_CTRL` | **Error** | Partial / incorrect control-path sync |
| `CDC_UNSYNC_DATA` | **Error** | Partial / incorrect data-path sync |
| `CDC_SYNC_CTRL` | Info | Control path synchronized |
| `CDC_SYNC_DATA` | Info | Data path synchronized |
| `CDC_SYNC_CTRL_SAM_SYNCPORT` | Info | Control sync inside SAM block |
| `CDC_SYNC_DATA_SAM_SYNCPORT` | Info | Data sync inside SAM block |
| `CDC_IGNOREPATH_USER_CONSTRAINT` | Info | Waived by `set_clock_groups -logically_exclusive` etc. |
| `CDC_IGNORE_PATH_COMMAND` | Info | Waived by `set_cdc_ignore_path` |

### Ignored-path reason codes

`USER_QUASI_STATIC_SRC`, `USER_QUASI_STATIC_DEST`, `USER_QUASI_STATIC_PATH`, `SEMI_QUASI_STATIC_SRC`, `CDC_UNOBSERVABLE_CROSSING`.

## User constraints and waivers

| Mechanism | Use |
|-----------|-----|
| `set_sync_attribute` | Declare sync on signal/cell |
| `configure_cdc_userpath_nff_sync` | User NFF path |
| `configure_cdc_userpath_data_sync` | User data sync path |
| `configure_cdc_userpath_analysis` | Custom path analysis |
| `configure_cdc_nff_sync` | NFF depth / recognition |
| `configure_cdc_data_sync` | Data sync schemes |
| `configure_cdc_crossing` | Crossing filters |
| `waive_cdc` | Documented waiver only |

**FPGA:** Prefer RTL fix using `@rtl-design` patterns over waivers. Align NFF depth with Quartus synchronizer chain (`report_metastability` → `@timing-analysis`).

## Tcl example

```tcl
check_cdc -type setup
check_cdc -type integ    ;# optional
check_cdc -type sync
report_violations -app CDC -file sync.rpt
get_cdc_paths
get_synchronizer_cells
```

## PDF opt-in

UG Ch. 5 — Synchronization Schemes, Tags for Clock Domain Crossings Violations (pages ~344–366+). Extract `CDC_VERIFY` has 0 pages — use PDF for full detail.
