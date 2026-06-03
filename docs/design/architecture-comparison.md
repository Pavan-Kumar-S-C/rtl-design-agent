# Architecture Comparison: Legacy Tod Synchronizer vs. KM XCVR ToD Counter

## Contents

- [1. Clock Domain Crossing](#1-clock-domain-crossing)
- [2. Control Signaling](#2-control-signaling)
- [3. Data Integrity](#3-data-integrity)
- [4. Metastability Handling](#4-metastability-handling)
- [5. Latency Model](#5-latency-model)
- [6. Summary](#6-summary)

---

## 1. Clock Domain Crossing

### Legacy (`altera_eth_1588_tod_synchronizer`)

Operates across **two (or three) independent clock domains**: `clk_master`, `clk_slave`, and optionally `clk_sampling` (modes 0–15).

**Multi-bit bus CDC via direct sampling.** The 96-bit ToD + 16-bit checksum = 112-bit `transfer_bus` crosses from `clk_master` to `clk_slave` through a **plain 2-stage register chain** — not an actual per-bit synchronizer:

```verilog
// tod_sync_clk_align.sv — slave side
reception_bus0 <= transfer_bus_delayed;   // 1st flop in clk_slave
reception_bus1 <= reception_bus0;          // 2nd flop in clk_slave
```

The only structural protection on this 112-bit bus is physical constraint (`set_net_delay`, `set_max_skew`) plus a post-hoc checksum comparison. There is no handshake, no gray coding, and no hold-off protocol on the data bus itself.

A **separate toggle bit** (`toggle_transfer`) is passed through the same 2-flop chain and used for edge detection on the slave side. The toggle bit has no additional synchronization depth beyond the data bus.

Modes 0–15 also introduce a **third clock domain** (`clk_sampling`) with a gray-coded async FIFO for phase accumulation data, adding area and SDC complexity.

### New (`km_xcvr_mps_tod_counter`)

Operates in a **single clock domain** — the SerDes word clock (`i_clk`).

The **only CDC crossing** is the 1-bit reference signal `i_ref_signal`, which is assumed to pass through a standard **2-flop external bit synchronizer** before reaching the module. Internally, the design adds two more pipeline flops for isolation:

```systemverilog
// km_xcvr_mps_tod_counter.sv
ref_signal_d1  <= i_ref_signal;   // capture in local clock domain
tick           <= tick_next;       // additional isolation flop
```

No multi-bit data ever crosses a clock boundary. The entire ToD computation — period measurement, filtering, division, phase correction — runs synchronously in `i_clk`.

### Key Difference

| Aspect | Legacy | New |
|--------|--------|-----|
| Number of clock domains | 2–3 (`clk_master`, `clk_slave`, `clk_sampling`) | 1 (`i_clk`) |
| Multi-bit bus crossing | 112-bit bus via 2-flop register chain | None — single-domain design |
| CDC on reference signal | Full ToD snapshot sent across domains | 1-bit toggle/edge only |
| Gray-coded FIFO | Yes (modes 0–15, for phase accumulation) | Not needed |
| Third sampling clock | Required for modes 0–15 | Eliminated |

---

## 2. Control Signaling

### Legacy

Uses **toggle-based signaling with derived clock enables**. A toggle bit (`toggle_bit_master`) flips at every `clken_master` pulse and is sampled by the slave on `clken_slave_delay1`. The slave detects a change to know when new data has arrived:

```verilog
// tod_sync_clk_align.sv
assign toggle = toggle_bit_slave ^ toggle_bit_slave_old;  // edge detect
```

The toggle is sensitive to **both rising and falling edges**, meaning rising-to-falling and falling-to-rising asymmetry in the synchronizer flops can cause timing margin differences between consecutive transfers.

Additional control signals (`start_tod_sync`, `reset_master`, `init_count`, `start_count`, `stop_count`) each use dedicated multi-flop bit synchronizers and form an ad-hoc FSM for PPM measurement sequencing.

### New

Uses **configurable edge or toggle detection** on a single reference signal:

```systemverilog
// km_xcvr_mps_tod_counter.sv
assign tick_next = i_cfg_ref_time_toggle
    ? (i_ref_signal ^ ref_signal_d1)       // toggle mode: any edge
    : (i_ref_signal && !ref_signal_d1);    // edge mode: rising only
```

**Rising-edge-only mode** eliminates the asymmetry problem documented in the legacy HAS. All downstream processing is driven by a single `tick` signal propagated through a **deterministic pipeline**:

```
active_tick → active_tick_d1 → active_tick_d2 → active_tick_d3 → active_tick_d4
```

There are no ad-hoc FSMs for PPM measurement. The `i_enable` signal gates activation, and `init` triggers orderly pipeline reset — both operate in the same clock domain with no synchronizer latency.

### Key Difference

| Aspect | Legacy | New |
|--------|--------|-----|
| Toggle detection | Both edges (asymmetry risk) | Configurable: rising-only or both edges |
| Control signals crossing CDC | 6+ individual bit synchronizers | 1 external sync on `i_ref_signal` |
| Internal control pipeline | Ad-hoc FSMs across 2 domains | Deterministic tick pipeline in single domain |
| PPM sequencing | Multi-signal handshake (`init_count`, `start_count`, `stop_count`) | Eliminated — continuous period measurement |

---

## 3. Data Integrity

### Legacy

Relies on a **16-bit additive checksum** computed over 7 pipeline stages on the master side and recomputed on the slave side:

```verilog
chks_ok = (chks_slave_old_delay3 == chks_slave_final);
```

Combined with a toggle stability check and a 3-state FSM (`IDL → WAIT → TRANSFER`), the composite valid signal is:

```verilog
tod_valid = toggle_ok & chks_ok & state_ok;
```

**Risk of partial updates:** Because the 112-bit bus crosses without a handshake protocol, individual bits can go metastable independently. The checksum is a probabilistic detector — it cannot guarantee catching all corruption. A metastable event affecting both data and checksum bits in a consistent way (low probability but non-zero for 112 bits) would pass undetected.

When a checksum fails, the slave **silently holds its previous value** with no error reporting, alarm, or retry mechanism.

### New

There is **no multi-bit data crossing**, so data integrity is inherent to the architecture. The single-bit reference signal crossing cannot experience partial-update corruption.

Within the single clock domain, data consistency is ensured by:

1. **Sample-and-hold on tick events:**
   ```systemverilog
   if (active_tick) begin
       period_sampled <= period;   // atomic snapshot on reference tick
   end
   ```
   All pipeline stages operate on data captured in the same clock cycle.

2. **Software-triggered coherent status snapshot:**
   ```systemverilog
   if (i_cfg_status_update) begin
       o_sts_ref_time   <= ref_time[...];
       o_sts_local_time <= local_time[...];
       // all status captured atomically
   end
   ```

3. **12 distinct overflow/error signals** with configurable masking via `i_cfg_sync_err`, any of which can force `o_sync_done` low.

### Key Difference

| Aspect | Legacy | New |
|--------|--------|-----|
| Multi-bit integrity mechanism | 16-bit checksum (probabilistic) | Not needed — no multi-bit CDC |
| Partial update risk | Yes — 112-bit bus can have per-bit metastability | None — single-domain pipeline |
| Error detection | Checksum pass/fail only; no reporting | 12 named error signals with configurable mask |
| Error response | Silent hold of previous value | `o_sync_done` deasserted; errors visible to software |
| Atomic data capture | Toggle + checksum + FSM gating | Sample-and-hold at tick; SW-triggered status snapshot |

---

## 4. Metastability Handling

### Legacy

**Minimal synchronization on multi-bit paths.** The 112-bit `transfer_bus` uses only a 2-register chain (`reception_bus0 → reception_bus1`), relying on:
- SDC `set_net_delay -max` and `set_max_skew` constraints for physical routing proximity
- Data stability for ≥3 derived clock periods before sampling
- Checksum to detect corruption after the fact

The `SYNCHRONIZER_IDENTIFICATION OFF` attribute appears on several cross-domain registers (e.g., `ppm_diff`, `ppm_in_ns_fns_per_cycle_pre`, `period_reg`), explicitly removing them from Quartus metastability analysis:

```verilog
(* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [20:0] ppm_diff;
```

Single-bit control signals use the `_std_synchr_nocut` synchronizer (depth 2–3) with proper `SYNCHRONIZER_IDENTIFICATION FORCED` attributes. The toggle-handshake clock crosser (`_clock_crosser.v`) uses **6-stage** synchronization on the forward path but is only used for phase measurement readback, not for the main ToD transfer.

The async FIFO (modes 0–15) uses 2-stage synchronizers on gray-coded pointers — the only structurally correct multi-bit CDC in the legacy design.

### New

**Single-domain design eliminates internal metastability risk.** The only metastability exposure is on the 1-bit `i_ref_signal`:

1. **External 2-flop bit synchronizer** (assumed in system integration)
2. **Internal pipeline isolation:** `ref_signal_d1 → tick_next → tick` — two additional registered stages before any data-path logic observes the signal

The CDC library (available for system-level integration) provides:

| Synchronizer | Depth | Use |
|--------------|-------|-----|
| `km_hssi_bitsync` | 2-stage | Standard bit sync for all crossings |
| `km_hssi_bitsync3` | 3-stage | Higher MTBF for critical paths |
| `km_hssi_altr_hps_rstnsync` | 2-stage AASD | Reset synchronizer |
| `km_hssi_vecsync_handshake` | Ready/valid with 2-stage sync on handshake | Multi-bit vector crossing |

All library synchronizers include `SYNCHRONIZER_IDENTIFICATION FORCED`, `DONT_MERGE_REGISTER`, and `PRESERVE_REGISTER` attributes.

Residual metastability jitter (±0.5 clock cycles from the external 2-flop sync) is **absorbed by the dual exponential smoothing filters** rather than treated as a hard error.

### Key Difference

| Aspect | Legacy | New |
|--------|--------|-----|
| Main data path synchronization | 2-flop register chain on 112-bit bus | Not applicable — single domain |
| Reference signal synchronization | N/A (full ToD sent across) | 2-flop external + 2-flop internal isolation |
| `SYNCHRONIZER_IDENTIFICATION OFF` usage | Yes — on PPM and phase registers | None |
| Metastability on multi-bit crossing | Probabilistic (checksum-based detection) | Eliminated by architecture |
| Residual jitter handling | Ignored; PPM counter averages over ~2^20 cycles | Absorbed by IIR filters (configurable k) |

---

## 5. Latency Model

### Legacy

Latency compensation is **static and mode-dependent**. Each of the 18+ sync modes has its own hardcoded `localparam` set:

```verilog
// tod_sync_clk_align.sv
localparam TRANSFER_LATENCY_COMPENSATION =
    ((M-2+9)*MASTER_PERIOD) + ((N+9)*SLAVE_PERIOD) + ACTUAL_NETDELAY;
```

The formula accounts for:
- Master-side pipeline: 1 register + 7 checksum + 1 transfer + (M−2) `clken_delay1`
- Wire propagation: hardcoded at **0.5 ns** (ACTUAL_NETDELAY = `48'h8000` fns) — a constant that varies with PVT, routing, and compilation seed
- Slave-side pipeline: 2-flop reception + FSM gating + latency addition stages

**Implicit and fragile.** Latency is different for 96-bit vs 64-bit ToD mode, for SYNC_MODE 2 vs all others, and for TOD_OUT=0 vs TOD_OUT=1. Comments in the source enumerate each cycle contribution but the calculation is scattered across `localparam` definitions and `generate` blocks, making it difficult to audit.

PPM drift correction is applied as a constant per-cycle increment (`slave_period_plus_ppm_drift`) derived from a periodic measurement window (~2^20 enables). It cannot adapt to rapid frequency changes.

### New

Latency compensation is **deterministic and explicitly documented** in the correction module:

```
Periods   Signal         Description
avg 1.5   i_ref_toggle   External CDC (2 flops)
   1      tick_next      Edge detection
   1      tick           Pipeline isolation
   1      local_time     Increment with div_period
   1      o_tod          Add correction
-----------------------------------------
avg 5.5   N              Total
```

The compensation factor is a single configurable expression:

```systemverilog
// km_xcvr_mps_tod_counter_correction.sv
assign mult_factor = {17'd5, 16'h8000} + {i_cfg_adjust_clks[31], i_cfg_adjust_clks};
//                    5       + 0.5     = 5.5 nominal, adjustable at runtime
```

Software can tune latency via `i_cfg_adjust_ns` (fixed ns offset) and `i_cfg_adjust_clks` (clock-period-relative offset) without recompilation.

The **only variable component** is the external 2-flop CDC jitter (1 to 2 cycles, average 1.5). This is not treated as a hard error — the dual exponential smoothing filters continuously remove it, while the feedback module prevents long-term phase accumulation.

### Key Difference

| Aspect | Legacy | New |
|--------|--------|-----|
| Latency model | Static `localparam` per mode (18+ variants) | Deterministic formula: avg 5.5 cycles |
| Wire delay assumption | Hardcoded 0.5 ns | Not applicable — single domain |
| Runtime adjustability | None — compile-time parameters only | `cfg_adjust_ns` + `cfg_adjust_clks` |
| Variable component | CDC jitter + routing variation + PPM measurement error | CDC jitter only (±0.5 cycles) |
| Drift correction | Periodic PPM counter (~2^20 cycle window) | Continuous IIR filtering + feedback |
| Frequency adaptability | Fixed per-cycle increment; cannot track rapid changes | Continuous period measurement; adapts every reference tick |
| Auditability | Scattered across `localparam` + `generate` blocks | Single documented pipeline with cycle-by-cycle breakdown |

---

## 6. Summary

The fundamental difference is architectural: the legacy synchronizer transfers **complete ToD snapshots across clock domains** using a wide bus with checksum-based error detection, while the new design transfers only a **1-bit timing reference** and performs all ToD computation locally in the destination clock domain.

This eliminates multi-bit CDC, removes probabilistic integrity checks, produces a deterministic and auditable latency model, and replaces periodic PPM measurement with continuous adaptive filtering — all while reducing the design to a single clock domain with no internal metastability exposure.
