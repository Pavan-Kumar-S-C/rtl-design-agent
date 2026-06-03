# Design document section router

Match user prompt words → read **only** the listed `##` section in the source file (from **Contents** through the next same-level heading).

**If no row matches** → use [standards/INDEX.md](../standards/INDEX.md) coding guidelines and **user input**; read a design doc only when the user names it or keywords clearly imply it. **Ask only when in doubt** (which doc/section, scope, or missing spec).

## Documents

| Source file | Topics | When to load |
|-------------|--------|--------------|
| [cdc-reusable-patterns.md](cdc-reusable-patterns.md) | CDC, sync, handshake, FIFO, gray, reset, latching | `cdc`, `synchronizer`, `bitsync`, `vecsync`, `pulse`, `fifo`, `gray`, `handshake`, `metastable` |
| [rtl-macro-library.md](rtl-macro-library.md) | Macro catalog, which `km_hssi_*` to use | `macro`, `library module`, `km_hssi`, `instantiate`, `reuse`, `standard cell` |
| [macro-library-user.md](macro-library-user.md) | User-supplied macro table | `macro library`, `company macro`, project macro |
| [architecture-comparison.md](architecture-comparison.md) | Legacy vs new ToD architecture | `legacy`, `tod synchronizer`, `architecture`, `comparison`, `altera_eth_1588` |
| [km-xcvr-tod-analysis.md](km-xcvr-tod-analysis.md) | km_xcvr_mps_tod_counter sync analysis | `km_xcvr`, `tod counter`, `mps_tod`, `ref_signal`, `tick`, `pipeline` |
| [legacy-tod-sync-analysis.md](legacy-tod-sync-analysis.md) | Legacy altera_eth_1588 ToD synchronizer CDC | `legacy tod`, `altera_eth_1588`, `tod_sync`, `transfer_bus`, `legacy synchronizer` |

## Section index — `cdc-reusable-patterns.md`

| Section (`##` heading) | Keywords | Examples folder |
|------------------------|----------|-----------------|
| 1. Synchronization Primitives | bitsync, 2-stage, 3-stage, synchronizer primitive | [examples/cdc/](../examples/cdc/) |
| 2. Handshake Logic | vecsync, pulse cross, lvlsync, req, ack, load, ready, valid | [examples/cdc/](../examples/cdc/) |
| 3. Data Latching Mechanisms | sample and hold, snapshot, tick pipeline, latch | [examples/latching/](../examples/latching/) |
| 4. Reset Synchronization | aasd, rstnsync, reset sync, init pipeline | [examples/resets/](../examples/resets/) |
| 5. Gray-Code Utilities (For Async FIFO Pointers) | gray, bintogray, graytobin, fifo pointer | [examples/cdc/](../examples/cdc/) |
| 6. Async FIFO (`km_hssi_async_fifo`) | async fifo, streaming cdc | [async_fifo_inst.sv](../examples/cdc/async_fifo_inst.sv) |
| 7. Selection Guide | which cdc, selection, primitive choice, macro choice | — |

## Section index — `rtl-macro-library.md`

| Section | Keywords |
|---------|----------|
| Agent rule: ask before instantiate | use macro, instantiate macro, library or inline |
| Quick selection guide | which macro, selection guide, scenario |
| Module index | km_hssi, module list, macro catalog |
| Inline patterns (no dedicated macro cell) | inline, custom logic, no macro, pattern only |

### Subsections (read parent + subsection when keyword is specific)

| Subsection (`###`) | Keywords |
|--------------------|----------|
| 1.1 2-Stage Bit Synchronizer | bitsync, 2ff, 2-flop |
| 1.2 3-Stage Bit Synchronizer | bitsync3, 3-flop, mtbf, higher mtbf | [bitsync3_inst.sv](../examples/cdc/bitsync3_inst.sv) |
| 1.3 Toggle/Edge Detector | toggle, edge detect, pps, ref signal, tick |
| 2.1 Vector Synchronizer — Auto-Detect | vecsync_cdc, auto detect | [vecsync_cdc_inst.sv](../examples/cdc/vecsync_cdc_inst.sv) |
| 2.2 Vector Synchronizer — Restricted | vecsync restricted |
| 2.3 Vector Synchronizer — Full Handshake | vecsync_handshake, load_data, ack_data |
| 2.4 Pulse Crosser | pulse_cross, pulse cdc | [pulse_cross_inst.sv](../examples/cdc/pulse_cross_inst.sv) |
| 2.5 Level Synchronizer | lvlsync, level sync |
| 3.1 Sample-and-Hold on Tick Event | sample hold, period_sampled, snapshot counter |
| 3.2 Software-Triggered Coherent Status Snapshot | status update, coherent read, cfg_status |
| 3.3 Deterministic Pipeline with Tick Propagation | active_tick, pipeline stage, dsp pipeline |
| 4.1 AASD Reset Synchronizer | aasd, altr_hps_rstnsync |
| 4.2 Pipelined Initialization Sequence | init pipeline, init_d1, init_d2 |

## Section index — `architecture-comparison.md`

| Section | Keywords |
|---------|----------|
| 1. Clock Domain Crossing | legacy cdc, 112-bit, transfer_bus, clk_master, clk_slave |
| 2. Control Signaling | toggle_transfer, clken, tick pipeline, control |
| 3. Data Integrity | checksum, chks_ok, partial update, atomic |
| 4. Metastability Handling | synchronizer identification, metastability | [synchronizer_attributes.sv](../examples/cdc/synchronizer_attributes.sv) |
| 5. Latency Model | latency compensation, adjust_clks, ppm |
| 6. Summary | overview, fundamental difference |

## Section index — `km-xcvr-tod-analysis.md`

| Section | Keywords |
|---------|----------|
| 1. Design Overview | hierarchy, module list, overview |
| 2. CDC Mechanism Used | toggle sync, gray fifo, handshake library |
| 3. Data Capture Strategy | period_sampled, shadow, double buffer, status snapshot |
| 4. Latency Handling | active_tick_d, 5.5 cycles, deterministic latency |
| 5. Protection Techniques | bitsync, pipeline isolation, safe sampling |

## Section index — `legacy-tod-sync-analysis.md`

| Section | Keywords |
|---------|----------|
| 1. Overview | legacy tod overview, altera_eth_1588 |
| 2. Clock domains | clk_master, clk_slave, clk_sampling |
| 3. Multi-bit bus CDC | transfer_bus, 112-bit, reception_bus |
| 4. Toggle and control signaling | toggle_transfer, toggle_bit |
| 5. Metastability and Quartus attributes | synchronizer identification off, ppm_diff, std_synchr |
| 6. Data integrity | checksum, chks_ok, tod_valid |
| 7. Risk summary and migration | legacy risk, migration |

## Reading procedure

1. Match keywords from user message + open RTL paths.
2. Load **one** primary design doc section (or ask if multiple apply).
3. Load linked `docs/examples/<topic>/` files cited in that section.
4. Load `docs/standards/<topic>.md` only for generic rules not covered in the design section.
