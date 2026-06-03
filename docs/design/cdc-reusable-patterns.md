# Reusable CDC & Synchronization Patterns from km_xcvr_tod

> Extracted from the KM XCVR common CDC library and ToD counter design.
> Each pattern includes the module interface, protocol, and instantiation template.

## Contents

- [1. Synchronization Primitives](#1-synchronization-primitives)
- [2. Handshake Logic](#2-handshake-logic)
- [3. Data Latching Mechanisms](#3-data-latching-mechanisms)
- [4. Reset Synchronization](#4-reset-synchronization)
- [5. Gray-Code Utilities (For Async FIFO Pointers)](#5-gray-code-utilities-for-async-fifo-pointers)
- [6. Async FIFO (`km_hssi_async_fifo`)](#6-async-fifo-km_hssi_async_fifo)
- [7. Selection Guide](#7-selection-guide)

**Golden RTL:** [docs/examples/cdc/](../examples/cdc/) · [docs/examples/resets/](../examples/resets/) · [docs/examples/latching/](../examples/latching/)

---

## 1. Synchronization Primitives

### 1.1 2-Stage Bit Synchronizer (`km_hssi_bitsync`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/bit_synchronizer/km_hssi_bitsync.sv`

The foundational CDC building block. Wraps the hardened `km_xcvr_common_altr_hps_bitsync` standard cell (double-flop synchronizer with `SYNCHRONIZER_IDENTIFICATION FORCED`, `DONT_MERGE_REGISTER`, `PRESERVE_REGISTER`).

**Interface:**

```systemverilog
module km_hssi_bitsync #(
    parameter DWIDTH            = 1,     // Width of bus to be sync'ed (per-bit sync)
    parameter RESET_VAL         = 0,     // Reset value: 0 → reset-clear, else → preset
    parameter DST_CLK_FREQ_MHZ  = 500,   // Destination clock frequency (MHz)
    parameter SRC_DATA_FREQ_MHZ = 100    // Average source data toggle rate (MHz)
) (
    input  logic                  clk,      // Destination clock
    input  logic                  rst_n,    // Async reset (active low)
    input  logic [DWIDTH-1:0]     data_in,  // Unsynchronized input
    output logic [DWIDTH-1:0]     data_out  // Synchronized output
);
```

**When to use:** Single-bit level signals crossing clock domains (enables, status flags, toggle handshake bits). Also used as the internal synchronizer for all higher-level CDC primitives.

**Instantiation template:**

```systemverilog
km_hssi_bitsync #(
    .DWIDTH            (1),
    .RESET_VAL         (0),
    .DST_CLK_FREQ_MHZ  (500),
    .SRC_DATA_FREQ_MHZ (100)
) u_my_sync (
    .clk      (dst_clk),
    .rst_n    (dst_rst_n),
    .data_in  (src_signal),
    .data_out (dst_signal_sync)
);
```

---

### 1.2 3-Stage Bit Synchronizer (`km_hssi_bitsync3`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/bit_synchronizer/km_hssi_bitsync3.sv`

Higher-MTBF variant (triple-flop). Includes gray-code detection logic for DV metastability simulation: verifies that multi-bit inputs change only one bit at a time (gray-code safe), and if not, randomizes per-bit metastability injection.

**Interface:** Same as `km_hssi_bitsync` with additional simulation parameters (`PLUS1_ONLY`, `MINUS1_ONLY`, `TX_MODE`, `DATA_META_OFF`, `DEASSERT_META_OFF`, `ENABLE_3TO1`).

**When to use:** Critical single-bit paths where standard 2-stage MTBF is insufficient (e.g., safety-critical control signals, very high frequency crossings).

---

### 1.3 Toggle/Edge Detector (From ToD Counter)

**Source:** `km_xcvr_mps_tod_counter.sv` (top-level, inline logic)

A reusable pattern for detecting toggles or rising edges on an externally synchronized reference signal, with pipeline isolation for timing closure.

**Pattern:**

```systemverilog
// --- Configurable Toggle/Edge Detector with Pipeline Isolation ---
//
// Assumptions:
//   i_ref_signal has already passed through an external 2-flop bitsync.
//   All logic below runs in a single clock domain (i_clk).

logic ref_signal_d1;   // Capture stage
logic tick_next;       // Combinational edge/toggle detect
logic tick;            // Isolated (registered) output

// Mode select: toggle (both edges) vs. rising-edge-only
assign tick_next = cfg_toggle_mode
    ? (i_ref_signal ^ ref_signal_d1)     // toggle: any change
    : (i_ref_signal && !ref_signal_d1);  // edge: rising only

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        ref_signal_d1 <= 1'b0;
        tick          <= 1'b0;
    end else begin
        ref_signal_d1 <= i_ref_signal;   // 1st pipeline stage
        tick          <= tick_next;       // 2nd pipeline stage (isolation)
    end
end
```

**Latency:** 2 internal cycles after the bitsync output (total avg 3.5 cycles from async source: 1.5 CDC + 1 detect + 1 isolation).

**When to use:** Receiving a 1-bit timing reference, PPS signal, or any toggle-encoded event from another clock domain. The rising-edge-only mode eliminates rise/fall asymmetry issues documented in the legacy design.

---

## 2. Handshake Logic

### 2.1 Vector Synchronizer — Auto-Detect (`km_hssi_vecsync_cdc`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/vector_synchronizer/km_hssi_vecsync_cdc.sv`

Transfers a multi-bit vector across clock domains using a **req/ack toggle handshake**. Automatically detects data changes and initiates transfer. Includes AASD reset synchronizers on both sides.

**Interface:**

```systemverilog
module km_hssi_vecsync_cdc #(
    parameter DWIDTH            = 1,     // Data width
    parameter RESET_VAL         = 0,     // Reset value
    parameter SRC_CLK_FREQ_MHZ  = 500,   // Source clock frequency
    parameter DST_CLK_FREQ_MHZ  = 500    // Destination clock frequency
) (
    input  logic                  i_wr_clk,          // Source clock
    input  logic                  i_rst_n,           // Async reset (active low)
    input  logic                  i_rd_clk,          // Destination clock
    input  logic [DWIDTH-1:0]     i_data_in,         // Data in (source domain)
    input  logic                  i_dft_byprst_b,    // DFT bypass reset
    input  logic                  i_dft_rstbypen_b,  // DFT reset bypass enable
    input  logic                  i_dft_scan_mode,   // DFT scan mode
    output logic [DWIDTH-1:0]     o_data_out         // Data out (destination domain)
);
```

**Protocol:**

```
Source Domain (wr_clk)              Destination Domain (rd_clk)
──────────────────────              ──────────────────────────
1. Detect data_in change
   (when req == ack)
2. Latch data into data_in_d1
3. Toggle req ─────────────────────▶ 4. bitsync req → req_rd_clk
                                     5. Detect req change (req ≠ req_d1)
                                     6. Capture data_in_d1 → data_out
                                     7. ack = req_d1 ◀───────── bitsync ack
8. Detect ack returned
9. Ready for next transfer
```

**When to use:** Configuration registers, status words, or any multi-bit data that changes infrequently and where you want automatic transfer on change. Fire-and-forget: no external control signals needed.

**Instantiation template:**

```systemverilog
km_hssi_vecsync_cdc #(
    .DWIDTH            (32),
    .RESET_VAL         (0),
    .SRC_CLK_FREQ_MHZ  (250),
    .DST_CLK_FREQ_MHZ  (500)
) u_cfg_sync (
    .i_wr_clk         (cfg_clk),
    .i_rst_n          (rst_n),
    .i_rd_clk         (core_clk),
    .i_data_in        (cfg_register),
    .i_dft_byprst_b   (1'b1),
    .i_dft_rstbypen_b (1'b1),
    .i_dft_scan_mode  (1'b0),
    .o_data_out       (cfg_register_sync)
);
```

---

### 2.2 Vector Synchronizer — Restricted (`km_hssi_vecsync`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/vector_synchronizer/restricted/km_hssi_vecsync.sv`

Identical req/ack protocol to `vecsync_cdc` but **without** internal reset synchronizers. Requires pre-synchronized resets on both clock domains.

**Interface:**

```systemverilog
module km_hssi_vecsync #(
    parameter DWIDTH            = 1,
    parameter RESET_VAL         = 0,
    parameter SRC_CLK_FREQ_MHZ  = 500,
    parameter DST_CLK_FREQ_MHZ  = 500
) (
    input  logic                  wr_clk,
    input  logic                  wr_rst_n,    // Must be synchronous to wr_clk
    input  logic                  rd_clk,
    input  logic                  rd_rst_n,    // Must be synchronous to rd_clk
    input  logic [DWIDTH-1:0]     data_in,
    output logic [DWIDTH-1:0]     data_out
);
```

**When to use:** Same as `vecsync_cdc` but when resets are already synchronized externally, saving area on the AASD synchronizers.

---

### 2.3 Vector Synchronizer — Full Handshake (`km_hssi_vecsync_handshake`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/vector_synchronizer/restricted/km_hssi_vecsync_handshake.sv`

Explicit **load/ready + valid/ack** flow control for multi-bit vector CDC. The source must explicitly request a transfer; the destination must explicitly acknowledge receipt.

**Interface:**

```systemverilog
module km_hssi_vecsync_handshake #(
    parameter DWIDTH            = 1,
    parameter RESET_VAL         = 0,
    parameter SRC_CLK_FREQ_MHZ  = 500,
    parameter DST_CLK_FREQ_MHZ  = 500
) (
    input  logic                  wr_clk,
    input  logic                  wr_rst_n,
    input  logic                  rd_clk,
    input  logic                  rd_rst_n,
    // Source side
    input  logic [DWIDTH-1:0]     data_in,
    input  logic                  load_data_in,   // Assert to initiate transfer
    output logic                  data_in_rdy2ld, // High when ready for new data
    // Destination side
    output logic [DWIDTH-1:0]     data_out,
    output logic                  data_out_vld,   // High when data_out is valid
    input  logic                  ack_data_out    // Consumer acknowledges receipt
);
```

**Protocol:**

```
Source Domain (wr_clk)              Destination Domain (rd_clk)
──────────────────────              ──────────────────────────
1. Wait for data_in_rdy2ld == 1
2. Assert load_data_in
   → data latched, req toggled
   → data_in_rdy2ld goes low
                                     3. req crosses via bitsync
                                     4. Detect req change
                                     5. data_out_vld asserted
                                     6. Consumer reads data_out
                                     7. Assert ack_data_out
                                        → ack sent back
8. ack returns via bitsync
9. data_in_rdy2ld goes high
```

**When to use:** Multi-bit data where the source needs backpressure (knows when the previous transfer completed) and the destination needs explicit valid indication. Ideal for command/response interfaces across clock domains.

**Instantiation template:**

```systemverilog
km_hssi_vecsync_handshake #(
    .DWIDTH            (64),
    .RESET_VAL         (0),
    .SRC_CLK_FREQ_MHZ  (250),
    .DST_CLK_FREQ_MHZ  (500)
) u_cmd_sync (
    .wr_clk          (src_clk),
    .wr_rst_n        (src_rst_n),
    .rd_clk          (dst_clk),
    .rd_rst_n        (dst_rst_n),
    .data_in         (cmd_data),
    .load_data_in    (cmd_valid && cmd_rdy),
    .data_in_rdy2ld  (cmd_rdy),
    .data_out        (cmd_data_sync),
    .data_out_vld    (cmd_valid_sync),
    .ack_data_out    (cmd_ack)
);
```

---

### 2.4 Pulse Crosser (`km_hssi_pulse_cross`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/pulse_cross/km_hssi_pulse_cross.sv`

Transfers a single-cycle pulse across clock domains with round-trip acknowledgment for backpressure. Supports early or late pulse output on the destination side.

**Interface:**

```systemverilog
module km_hssi_pulse_cross (
    input  logic i_clk,           // Source clock
    input  logic i_rstn,          // Source reset (active low)
    input  logic i_pulse,         // Input pulse (1 cycle in i_clk)
    input  logic i_oclk,          // Destination clock
    input  logic i_early_pulse,   // 0: output on falling edge of sync'd level
                                  // 1: output on rising edge of sync'd level
    input  logic i_orstn,         // Destination reset (active low)
    output logic o_next_i_pulse,  // Ready for next input pulse
    output logic o_out_pulse      // Output pulse (1 cycle in i_oclk)
);
```

**Protocol:**

```
i_clk domain:
1. Wait for o_next_i_pulse == 1
2. Assert i_pulse for 1 cycle
3. o_next_i_pulse goes low

i_oclk domain:
4. Internal level crosses via bitsync (forward path)
5. o_out_pulse asserted for 1 cycle
   - early_pulse=1: on rising edge of sync'd level (lower latency)
   - early_pulse=0: on falling edge (waits for complete round-trip)

i_clk domain:
6. Acknowledgment returns via bitsync (backward path)
7. o_next_i_pulse goes high → ready for next pulse
```

**Internal structure:** Uses 3 `km_hssi_bitsync` instances:
- Forward path: `l_in_pulse` → bitsync → `l_out_pulse`
- Backward path: `l_out_pulse` → bitsync → `l_in_pulse_back`
- Reset path: `orstn_act` → bitsync → `orstn_act_iclk`

**When to use:** Interrupt/event notification, trigger signals, or any single-cycle event that must be delivered exactly once across a clock boundary.

---

### 2.5 Level Synchronizer (`km_hssi_lvlsync`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/level_synchronizer/km_hssi_lvlsync.sv`

Per-bit level synchronizer with req/ack handshake. Supports two modes:
- **Level mode** (`EN_PULSE_MODE=0`): Tracks input level changes, output toggles to match.
- **Pulse mode** (`EN_PULSE_MODE=1`): Generates a single-cycle pulse on the destination when the source level transitions to the active state.

**Interface:**

```systemverilog
module km_hssi_lvlsync #(
    parameter EN_PULSE_MODE    = 0,     // 0: level tracking, 1: pulse on active edge
    parameter DWIDTH           = 1,     // Bus width (per-bit independent sync)
    parameter ACTIVE_LEVEL     = 1,     // 1: active high, 0: active low
    parameter DST_CLK_FREQ_MHZ = 500,
    parameter SRC_CLK_FREQ_MHZ = 500
) (
    input  wire               wr_clk,
    input  wire               rd_clk,
    input  wire               wr_rst_n,
    input  wire               rd_rst_n,
    input  wire [DWIDTH-1:0]  data_in,
    output reg  [DWIDTH-1:0]  data_out
);
```

**When to use:** Per-bit independent level/pulse crossing where each bit has its own handshake. Useful for multi-bit control buses where bits change independently.

---

## 3. Data Latching Mechanisms

### 3.1 Sample-and-Hold on Tick Event

**Source:** `km_xcvr_mps_tod_counter.sv` (period counter section)

Captures a free-running counter into a stable snapshot register on a specific event (reference tick). Downstream logic operates only on the snapshot, never on the live counter.

**Pattern:**

```systemverilog
// --- Sample-and-Hold: Stable Snapshot of Free-Running Counter ---

logic [WIDTH-1:0] counter;         // Free-running, updates every cycle
logic [WIDTH-1:0] counter_sampled; // Stable snapshot, updates on event

// Counter runs freely when enabled
assign counter_next = event_tick ? RESET_VAL : counter + INCREMENT;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter         <= '0;
        counter_sampled <= '0;
    end else begin
        if (enable) begin
            counter <= counter_next;
        end
        if (sample_event) begin
            counter_sampled <= counter;  // Atomic snapshot
        end
    end
end

// All downstream processing uses counter_sampled (stable between events)
```

**When to use:** Any scenario where a fast-changing value needs to be captured stably for multi-cycle processing (period measurement, timestamp capture, performance counters).

---

### 3.2 Software-Triggered Coherent Status Snapshot

**Source:** `km_xcvr_mps_tod_counter.sv` (status outputs section)

Captures all status fields atomically in a single clock cycle, triggered by a software write to a control register. Guarantees that software reads a consistent set of values.

**Pattern:**

```systemverilog
// --- Coherent Multi-Field Status Snapshot ---

// Internal signals (continuously updating)
logic        internal_valid;
logic [95:0] internal_tod;
logic [63:0] internal_filter_state;

// Status outputs (frozen until next update request)
logic        sts_valid;
logic [95:0] sts_tod;
logic [63:0] sts_filter_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sts_valid        <= '0;
        sts_tod          <= '0;
        sts_filter_state <= '0;
    end else begin
        if (cfg_status_update) begin    // Software-triggered snapshot
            sts_valid        <= internal_valid;
            sts_tod          <= internal_tod;
            sts_filter_state <= internal_filter_state;
            // All captured in the SAME clock edge → coherent read
        end
    end
end
```

**When to use:** Any register block where software must read multiple fields that are inter-dependent (timestamps + status, counter + overflow, paired min/max values).

---

### 3.3 Deterministic Pipeline with Tick Propagation

**Source:** `km_xcvr_mps_tod_counter.sv` (entire pipeline architecture)

A multi-stage processing pipeline where each stage is enabled by a delayed version of the same trigger event. Guarantees that each stage processes data produced by exactly the previous stage, with known cycle-accurate latency.

**Pattern:**

```systemverilog
// --- Deterministic N-Stage Tick Pipeline ---

logic active_tick;      // Stage 0 trigger
logic active_tick_d1;   // Stage 1 trigger
logic active_tick_d2;   // Stage 2 trigger
logic active_tick_d3;   // Stage 3 trigger

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        active_tick_d1 <= 1'b0;
        active_tick_d2 <= 1'b0;
        active_tick_d3 <= 1'b0;
    end else begin
        active_tick_d1 <= active_tick;
        active_tick_d2 <= active_tick_d1;
        active_tick_d3 <= active_tick_d2;
    end
end

// Stage 0: Capture raw data on active_tick
always_ff @(posedge clk) begin
    if (active_tick) begin
        stage0_data <= raw_input;
    end
end

// Stage 1: Process stage0 output on active_tick_d1
always_ff @(posedge clk) begin
    if (active_tick_d1) begin
        stage1_data <= process_a(stage0_data);
    end
end

// Stage 2: Process stage1 output on active_tick_d2
always_ff @(posedge clk) begin
    if (active_tick_d2) begin
        stage2_data <= process_b(stage1_data);
    end
end
```

**Key property:** Total pipeline latency = N cycles (deterministic, auditable). Each stage's output is stable for all cycles between ticks.

**When to use:** Multi-stage DSP-like processing (filtering, accumulation, correction) where known latency is required for compensation calculations.

---

## 4. Reset Synchronization

### 4.1 AASD Reset Synchronizer (`km_hssi_altr_hps_rstnsync`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/reset_synchronizer/km_hssi_altr_hps_rstnsync.sv`

**Async Assert, Synchronous Deassert (AASD)** reset synchronizer with DFT bypass. The standard pattern for safely distributing an asynchronous reset into a clock domain.

**Interface:**

```systemverilog
module km_hssi_altr_hps_rstnsync #(
    parameter MIN_PERIOD      = 1'b0,
    parameter METASTABILITY_EN = 1'b1,
    parameter SINGLE_BUS_META  = 1'b1,
    // ... additional DV/DFT parameters
) (
    input  wire clk,             // Destination clock
    input  wire i_rst_n,         // Asynchronous reset input (active low)
    input  wire dft_byprst_b,    // DFT bypass reset
    input  wire dft_rstbypen_b,  // DFT reset bypass enable
    input  wire dft_scan_mode,   // DFT scan mode select
    output wire sync_rst_n       // Synchronized reset output (AASD)
);
```

**Internal structure:**

```
                    ┌─────────┐
dft_scan_mode ──┐   │         │
dft_byprst_b ──┤►MUX├──► mux_rst_n ──► bitsync(rst_n=mux_rst_n, data_in=1'b1)
i_rst_n ───────┘   │         │                         │
                    └─────────┘                         ▼
                                              prescan_sync_rst_n
                                                        │
                                              ┌─────────▼─────────┐
                                 dft_byprst_b │                   │
                              dft_rstbypen_b ─┤►MUX───► sync_rst_n
                                              │                   │
                                              └───────────────────┘
```

**Behavior:**
- **Assert:** When `i_rst_n` goes low, `sync_rst_n` goes low **immediately** (asynchronous assert via the bitsync's async reset port).
- **Deassert:** When `i_rst_n` goes high, `sync_rst_n` goes high **synchronously** to `clk` (after 2-stage synchronization of the `1'b1` data input).

**When to use:** Every clock domain that receives an asynchronous reset. This is the mandatory reset entry point for all synchronous logic.

**Instantiation template:**

```systemverilog
km_hssi_altr_hps_rstnsync u_rst_sync (
    .clk            (domain_clk),
    .i_rst_n        (async_rst_n),
    .dft_byprst_b   (1'b1),           // Tie off if no DFT
    .dft_rstbypen_b (1'b1),           // Tie off if no DFT
    .dft_scan_mode  (1'b0),           // Tie off if no DFT
    .sync_rst_n     (domain_rst_n)    // Use this as the domain reset
);
```

---

### 4.2 Pipelined Initialization Sequence (From ToD Counter)

**Source:** `km_xcvr_mps_tod_counter.sv` (init pipeline)

A pattern for orderly multi-stage initialization where each stage must complete before the next begins, running in a single clock domain.

**Pattern:**

```systemverilog
// --- 3-Stage Init Pipeline ---
//
// init resets stage 0 modules (filters, counters)
// init_d1 resets stage 1 modules (secondary filters)
// init_d2 resets stage 2 modules (dividers, accumulators)

logic init_next;
logic init, init_d1, init_d2;

// Trigger init on rising edge of enable
assign init_next = !enable_d1 && i_enable;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        init    <= 1'b0;
        init_d1 <= 1'b0;
        init_d2 <= 1'b0;
    end else begin
        init    <= init_next;
        init_d1 <= init;
        init_d2 <= init_d1;
    end
end

// Each module uses a different init stage:
// Stage 0 modules:  if (init)    load_initial_value;
// Stage 1 modules:  if (init_d1) load_initial_value;
// Stage 2 modules:  if (init_d2) load_initial_value;
```

**When to use:** Multi-stage processing pipelines where each stage needs to be initialized with known values in order, and the initialization values of later stages depend on the outputs of earlier stages being loaded first.

---

## 5. Gray-Code Utilities (For Async FIFO Pointers)

### 5.1 Binary-to-Gray (`km_hssi_bintogray`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/gray_code/km_hssi_bintogray.sv`

```systemverilog
module km_hssi_bintogray #(
    parameter WIDTH = 2
) (
    input  wire [WIDTH-1:0] data_in,   // Binary input
    output wire [WIDTH-1:0] data_out   // Gray-coded output
);
    assign data_out = (data_in >> 1) ^ data_in;
endmodule
```

### 5.2 Gray-to-Binary (`km_hssi_graytobin`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/gray_code/km_hssi_graytobin.sv`

```systemverilog
module km_hssi_graytobin #(
    parameter WIDTH = 2
) (
    input  wire [WIDTH-1:0] data_in,   // Gray-coded input
    output wire [WIDTH-1:0] data_out   // Binary output
);
    genvar i;
    generate
        for (i = 0; i <= (WIDTH-1); i = i+1) begin: GRAY_TO_BIN
            assign data_out[i] = ^(data_in >> i);
        end
    endgenerate
endmodule
```

**When to use:** Async FIFO pointer CDC. Gray pointers change only 1 bit per increment, making them safe for multi-bit `bitsync` crossing (worst case: the synchronized value is either the old or new pointer, never a corrupted intermediate).

---

## 6. Async FIFO (`km_hssi_async_fifo`)

**Source:** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/async_fifo/km_hssi_async_fifo.sv`

Full asynchronous FIFO using gray-coded write/read pointers synchronized via `km_hssi_bitsync`. Includes configurable empty/full thresholds, partial-empty/partial-full flags, underrun/overflow detection, and DFT support.

**Interface (key ports):**

```systemverilog
module km_hssi_async_fifo #(
    parameter DWIDTH           = 41,
    parameter AWIDTH           = 6,    // Depth = 2^AWIDTH
    parameter DST_CLK_FREQ_MHZ = 500,
    parameter SRC_CLK_FREQ_MHZ = 500
) (
    // Write domain
    input  wire                wr_rst_n, wr_clk, wr_en,
    input  wire [DWIDTH-1:0]  wr_data,
    output reg                wr_empty, wr_full, wr_pempty, wr_pfull,
    // Read domain
    input  wire                rd_rst_n, rd_clk, rd_en,
    output wire [DWIDTH-1:0]  o_rd_data,
    output reg                rd_empty, rd_full, rd_pempty, rd_pfull,
    // Thresholds
    input  wire [AWIDTH:0]    r_pempty, r_pfull, r_empty, r_full,
    input  wire                r_rd_empty, r_wr_full,
    // Status
    output wire [AWIDTH:0]    rd_numdata, wr_numdata,
    output reg                fifo_underrun, fifo_overflow,
    // DFT
    input  wire                i_tdf_en
);
```

**When to use:** High-throughput streaming data between clock domains where handshake latency is unacceptable. The FIFO absorbs rate differences and provides flow control via empty/full flags.

---

## 7. Selection Guide

| Scenario | Recommended Primitive |
|----------|----------------------|
| 1-bit flag/enable crossing | `km_hssi_bitsync` |
| 1-bit critical path (higher MTBF) | `km_hssi_bitsync3` |
| 1-bit timing reference / PPS | Toggle/edge detector pattern (Section 1.3) |
| Single pulse event crossing | `km_hssi_pulse_cross` |
| Multi-bit config register (slow, auto) | `km_hssi_vecsync_cdc` or `km_hssi_vecsync` |
| Multi-bit with explicit flow control | `km_hssi_vecsync_handshake` |
| Per-bit level/pulse tracking | `km_hssi_lvlsync` |
| Streaming data between domains | `km_hssi_async_fifo` |
| Async reset distribution | `km_hssi_altr_hps_rstnsync` |
| Stable capture of live counter | Sample-and-hold pattern (Section 3.1) |
| Multi-field register read consistency | Coherent snapshot pattern (Section 3.2) |
| Multi-stage DSP with known latency | Tick pipeline pattern (Section 3.3) |
