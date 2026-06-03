# km_xcvr_tod (New Design) — Synchronization Logic Analysis

## Contents

- [1. Design Overview](#1-design-overview)
- [2. CDC Mechanism Used](#2-cdc-mechanism-used)
- [3. Data Capture Strategy](#3-data-capture-strategy)
- [4. Latency Handling](#4-latency-handling)
- [5. Protection Techniques](#5-protection-techniques)

---

## 1. Design Overview

The `km_xcvr_mps_tod_counter` is a digital PLL-based Time-of-Day (ToD) synchronizer operating entirely in the **SerDes word clock domain** (`i_clk`). It receives an external reference signal (`i_ref_signal`) — already assumed to have passed through an external 2-flop CDC — and uses a cascaded filter pipeline to reconstruct an accurate ToD output.

### Module Hierarchy

```
km_xcvr_mps_tod_counter (top)
├── km_xcvr_mps_tod_counter_ref_time        — Reference time accumulator + rate generator
├── km_xcvr_mps_tod_counter_filter (×4)     — Exponential smoothing IIR filters
│   ├── period_filter1                      — Period filter stage 1 (unsigned)
│   ├── period_filter2                      — Period filter stage 2 (unsigned)
│   ├── phase_filter1                       — Phase filter stage 1 (signed)
│   └── phase_filter2                       — Phase filter stage 2 (signed)
├── km_xcvr_mps_tod_counter_divider         — Fixed-point unsigned divider (ref_period / filtered_period)
│   └── km_xcvr_mps_tod_counter_divider_int — Integer long-division core
├── km_xcvr_mps_tod_counter_local_time      — Free-running local time counter
├── km_xcvr_mps_tod_counter_tod_diff        — Phase difference (local_time − ref_time)
├── km_xcvr_mps_tod_counter_multiplier      — Fixed-point multiplier (signed × unsigned)
│   └── km_xcvr_mps_tod_counter_multiplier_int — Integer multiplication core
├── km_xcvr_mps_tod_counter_correction      — ToD = local_time + correction
├── km_xcvr_mps_tod_counter_feedback        — DC removal feedback into div_period
└── km_xcvr_mps_tod_counter_monitor         — Rate-of-change monitor + convergence detector
```

---

## 2. CDC Mechanism Used

### 2.1 Toggle Synchronizer — YES (External, 2-Stage)

The reference signal `i_ref_signal` is assumed to be **already synchronized externally** through a 2-flop synchronizer before arriving at the ToD counter. The correction module explicitly documents this:

```
// Periods   Signal         Description
// avg 1.5   i_ref_toggle   delay through external CDC with 2 flops
//    1      tick_next      toggle on i_ref_toggle detected on next posedge clk
//    1      tick           flop to isolate timing from inputs
```

The design supports both **toggle mode** (both edges) and **edge-detect mode** (rising edge only):

```systemverilog
assign tick_next = i_cfg_ref_time_toggle
    ? (i_ref_signal ^ ref_signal_d1)       // toggle: detect any change
    : (i_ref_signal && !ref_signal_d1);    // edge: detect rising only
```

### 2.2 Gray-Coded Counter — YES (Available in CDC Library)

The CDC library includes gray-code primitives used by the async FIFO:

| Module | Purpose |
|--------|---------|
| `km_hssi_bintogray` | Binary-to-Gray conversion: `data_out = (data_in>>1) ^ data_in` |
| `km_hssi_graytobin` | Gray-to-Binary conversion via XOR cascade |
| `km_hssi_async_fifo` | Full async FIFO using gray-coded write/read pointers with 2-stage bit synchronizers |

The async FIFO uses gray-coded address pointers (`wr_addr_gry`, `rd_addr_gry`) synchronized through `km_hssi_bitsync` (2-stage synchronizer) for safe CDC pointer passing.

**However**: The ToD counter core itself does **not** use gray-coded counters internally — it operates in a single clock domain and relies on a different synchronization strategy (see Section 3).

### 2.3 Ready/Valid Handshake — YES (Available in CDC Library)

The CDC library provides multiple handshake-based vector synchronizers:

| Module | Handshake Type |
|--------|---------------|
| `km_hssi_vecsync_cdc` | Req/Ack toggle handshake with data latch (auto-detect data change) |
| `km_hssi_vecsync` | Req/Ack toggle handshake (restricted variant, same protocol) |
| `km_hssi_vecsync_handshake` | Full ready/valid: `load_data_in`, `data_in_rdy2ld`, `data_out_vld`, `ack_data_out` |
| `km_hssi_pulse_cross` | Pulse CDC with round-trip acknowledgment (`o_next_i_pulse` ready signal) |
| `km_hssi_lvlsync` | Per-bit level synchronizer with req/ack handshake |

The `km_hssi_vecsync_handshake` provides explicit flow control:
- **Source side**: `data_in_rdy2ld` (ready to load), `load_data_in` (valid from source)
- **Destination side**: `data_out_vld` (data valid), `ack_data_out` (consumer acknowledgment)

---

## 3. Data Capture Strategy

### 3.1 Shadow Registers — NO (Not Used)

The design does **not** use shadow/holding registers for atomic multi-field capture. Instead, it uses a fundamentally different approach: **single-clock-domain processing with pipelined tick propagation**.

### 3.2 Double-Buffering — NO (Not the Traditional Approach)

Instead of double-buffering, the design uses:

#### Period Sampling (Implicit Double-Buffer Pattern)
```systemverilog
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (enable_d1) begin
        period <= period_next;        // free-running counter
    end
    if (active_tick) begin
        period_sampled <= period;     // snapshot on tick edge
    end
end
```

The `period` counter runs freely while `period_sampled` captures a stable snapshot on every reference tick. This is a **sample-and-hold** pattern rather than classical double-buffering.

#### Status Register Snapshot
```systemverilog
if (i_cfg_status_update) begin
    o_sts_tod_valid      <= o_tod_valid;
    o_sts_sync_done      <= o_sync_done;
    o_sts_ref_time       <= ref_time[...];
    o_sts_local_time     <= local_time[...];
    // ... all status captured atomically on cfg_status_update
end
```

This is a **software-triggered coherent snapshot** — all status outputs are captured in the same clock cycle when `i_cfg_status_update` is asserted, ensuring consistency for software reads.

---

## 4. Latency Handling

### 4.1 Deterministic Pipeline Latency — YES

The design uses a **deterministic, exactly-timed pipeline** for filter processing. Each pipeline stage is clocked by a delayed version of `active_tick`:

```
Stage   Signal              Operations
──────────────────────────────────────────────────────────
  0     active_tick         Period counter sample, ref_time update
  1     active_tick_d1      Period filter 1, phase_diff calculation
  2     active_tick_d2      Period filter 2, phase_filter1
  3     active_tick_d3      Divider start, phase_filter2
  4     active_tick_d4      Correction calculation
```

Each `active_tick_dN` is a simple registered delay:
```systemverilog
active_tick_d1 <= active_tick;
active_tick_d2 <= active_tick_d1;
active_tick_d3 <= active_tick_d2;
active_tick_d4 <= active_tick_d3;
```

### 4.2 Total Latency Budget (Deterministic)

The correction module documents the **exact total latency** from reference toggle to ToD output:

| Cycles | Signal | Description |
|--------|--------|-------------|
| avg 1.5 | `i_ref_toggle` | External CDC with 2 flops (variable: 1–2 cycles) |
| 1 | `tick_next` | Toggle/edge detection |
| 1 | `tick` | Pipeline isolation flop |
| 1 | `local_time` | Increment with `div_period` |
| 1 | `o_tod` | Add correction to `local_time` |
| **avg 5.5** | **N** | **Total pipeline latency** |

This latency is **compensated deterministically** in the correction calculation:
```systemverilog
// correction = cfg_adjust_ns + N * period - phase_filter
// where N = 5.5 (average CDC + pipeline delay)
assign mult_factor = {17'd5, 16'h8000} + {i_cfg_adjust_clks[31], i_cfg_adjust_clks};
//                    ^^^^^ ^^^^^^^^^
//                    5     + 0.5      = 5.5 nominal
```

### 4.3 Variable Component

The **only variable latency** is the external 2-flop CDC synchronizer (1 to 2 clock cycles, average 1.5). This is handled by using 5.5 as the **average** compensation factor, with the remaining jitter absorbed by the phase filters.

---

## 5. Protection Techniques

### 5.1 Multi-Stage Synchronizers — YES

The CDC library provides multiple synchronizer depths:

| Module | Stages | Usage |
|--------|--------|-------|
| `km_hssi_bitsync` / `km_xcvr_common_altr_hps_bitsync` | **2-stage** | Standard bit synchronizer for all CDC bit crossings |
| `km_hssi_bitsync3` | **3-stage** | Higher MTBF synchronizer for critical paths |
| `km_hssi_altr_hps_rstnsync` | **2-stage** (AASD) | Reset synchronizer: async assert, sync deassert |

All vector/level/pulse synchronizers internally instantiate `km_hssi_bitsync` (2-stage) for their handshake signals. The bitsync includes:
- Configurable `METASTABILITY_EN` for simulation
- `SINGLE_BUS_META` for coherent bus metastability modeling
- Gray-code detection in `bitsync3` for verification validation

### 5.2 Safe Sampling Window — YES

Multiple techniques ensure safe sampling:

#### a) Reference Signal Pipeline Isolation
```systemverilog
ref_signal_d1 <= i_ref_signal;   // capture in local domain
tick          <= tick_next;       // additional isolation flop
```
Two flops of pipeline isolation after the external CDC output, ensuring the toggle detection logic operates on stable, locally-registered data.

#### b) Period Counter Snapshot
The period counter value is sampled into `period_sampled` synchronous to the tick event, ensuring stable data for the filter pipeline.

#### c) Handshake-Based Vector CDC
All vector synchronizers (`km_hssi_vecsync`, `km_hssi_vecsync_cdc`, `km_hssi_vecsync_handshake`) use a **toggle-based req/ack protocol**:
1. Source latches data and toggles `req`
2. `req` crosses via 2-stage bitsync to destination
3. Destination captures data and sends back `ack` via 2-stage bitsync
4. Source waits for `ack` before accepting new data

This guarantees the source data is **stable for the entire crossing window**.

### 5.3 Pipelining Stages — YES (5-Stage Tick Pipeline)

The design employs a **5-stage deterministic pipeline** driven by the `active_tick` chain:

```
┌──────────┐   ┌─────────────────┐   ┌─────────────────┐   ┌──────────────┐   ┌────────────┐
│  Stage 0  │──▶│    Stage 1      │──▶│    Stage 2      │──▶│   Stage 3    │──▶│  Stage 4   │
│           │   │                 │   │                 │   │              │   │            │
│ period    │   │ period_filter1  │   │ period_filter2  │   │ divider      │   │ correction │
│ sample    │   │ phase_diff      │   │ phase_filter1   │   │ phase_flt2   │   │ ToD calc   │
│ ref_time  │   │                 │   │                 │   │              │   │            │
└──────────┘   └─────────────────┘   └─────────────────┘   └──────────────┘   └────────────┘
active_tick     active_tick_d1        active_tick_d2        active_tick_d3     active_tick_d4
```

Additionally:
- **Initialization pipeline**: `init → init_d1 → init_d2` (3-stage) for orderly filter reset
- **Divider state machine**: `DIV_IDLE → DIV_BUSY → DIV_PENDING` handles variable-latency division without stalling the pipeline
- **Local time counter**: Runs on `active` (every cycle when enabled), independent of tick pipeline

### 5.4 Overflow Protection — Comprehensive

Every arithmetic stage has explicit overflow detection:

| Error Signal | Module | Protection |
|-------------|--------|------------|
| `period_flt1_ovf` | period_filter1 | Filter state overflow (MSB check) |
| `period_flt2_ovf` | period_filter2 | Filter state overflow |
| `div_by_zero` | divider | Zero divisor check |
| `div_ovf` | divider | Quotient overflow |
| `phase_diff_ovf` | tod_diff | ±536M ns range check (3-bit MSB pattern) |
| `phase_flt1_ovf` | phase_filter1 | Signed filter overflow (MSB pair check) |
| `phase_flt2_ovf` | phase_filter2 | Signed filter overflow |
| `correction_ovf` | correction | ±536M ns range check (5-bit MSB pattern) |
| `mon_diff_ovf` | monitor | ToD rate change overflow |
| `mon_filter_ovf` | monitor | Monitor filter overflow |
| `mon_clz_fail` | monitor | CLZ quality degradation |
| `mon_avg_fail` | monitor | Average quality degradation |

Configurable error masking via `i_cfg_sync_err` allows selecting which errors force `o_sync_done` low.

### 5.5 Feedback Saturation Protection

The feedback module includes saturation to prevent runaway corrections:
```systemverilog
if (div_period_full[PHASE_WIDTH])
    div_period_next = '0;                    // negative → clamp to zero
else if (div_period_full[PHASE_WIDTH:16+PHASE_FNS_WIDTH] != '0)
    div_period_next = '1;                    // overflow → clamp to max
else
    div_period_next = div_period_full[...];  // normal path
```

### 5.6 Convergence Monitoring & Start Mode

The monitor tracks convergence quality using:
1. **CLZ (Count Leading Zeros)**: Measures ToD rate stability — higher CLZ = smaller rate changes
2. **Filtered Average**: Exponential moving average of CLZ values
3. **Dual-threshold hysteresis**: Separate good/bad thresholds prevent oscillation:
   - `o_sync_done` asserted when both `clz_ok` AND `avg_ok`
   - **Start mode**: Uses aggressive filter parameters (`start_*_k`) until quality reaches `start_limit_hi`, then switches to normal parameters

---

## 6. Summary Comparison Table

| Feature | km_xcvr_tod (New Design) |
|---------|--------------------------|
| **CDC Mechanism** | External 2-flop bitsync + toggle/edge detection |
| **Toggle Synchronizer** | Yes — external, supports both edges or rising-only |
| **Gray-Coded Counter** | Available in library (async FIFO), not needed in core |
| **Ready/Valid Handshake** | Available in library (`vecsync_handshake`), not needed in core |
| **Data Capture** | Sample-and-hold (period counter) + software-triggered status snapshot |
| **Shadow Registers** | No — single-domain pipeline eliminates need |
| **Double-Buffering** | No — deterministic pipeline with tick propagation |
| **Latency Type** | **Deterministic** — 5.5 cycles average, compensated in correction |
| **Variable Component** | Only external CDC jitter (±0.5 cycles), absorbed by filters |
| **Multi-Stage Sync** | 2-stage (bitsync) and 3-stage (bitsync3) available |
| **Safe Sampling** | Pipeline isolation flops + stable data latching on tick |
| **Pipelining** | 5-stage tick pipeline + 3-stage init pipeline |
| **Overflow Protection** | 12 distinct error signals with configurable masking |
| **Feedback Protection** | Saturation clamping on period correction |
| **Convergence Detection** | CLZ + filtered average with dual-threshold hysteresis |

---

## 7. Key Architectural Insight

The km_xcvr_tod design avoids complex multi-clock-domain synchronization by keeping the **entire ToD computation in a single clock domain** (SerDes word clock). The only CDC crossing is the reference signal input, which is handled externally. This single-domain approach:

1. **Eliminates coherency issues** — no need for shadow registers or atomic multi-field capture
2. **Enables deterministic latency** — exact cycle counts through the pipeline are known and compensated
3. **Simplifies verification** — all internal timing is synchronous
4. **Relies on filtering** — the exponential smoothing filters (configurable k parameters) absorb CDC jitter and measurement noise

The design is fundamentally a **software/digital PLL**: the reference signal provides timing ticks, the period/phase filters act as the loop filter, the divider computes the VCO frequency (clock period), and the feedback path provides DC offset removal — all implemented as deterministic fixed-point arithmetic in a single clock domain.
