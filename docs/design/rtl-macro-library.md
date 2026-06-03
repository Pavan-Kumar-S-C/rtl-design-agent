# RTL macro / reusable module library (catalog)

**Meaning of “macro” here:** packaged **project RTL library modules** to instantiate (e.g. `km_hssi_bitsync`).

**Altera IP / megafunctions (IP Catalog):** separate doc — [megafunctions-ip-cores.md](../standards/megafunctions-ip-cores.md) from [ug_intro_to_megafunctions-683102-848730.pdf](../standards/ug_intro_to_megafunctions-683102-848730.pdf). Agent **asks** IP Catalog vs custom RTL for FIFO/RAM/DSP/PLL-type needs.

**Detailed patterns:** [cdc-reusable-patterns.md](cdc-reusable-patterns.md) (per-macro interfaces and protocols).

**Examples:** [docs/examples/](../examples/) — see [examples/README.md](../examples/README.md).

**Optional supplement:** [macro-library-user.md](macro-library-user.md) for extra project macros.

## Contents

- [Agent rule: ask before instantiate](#agent-rule-ask-before-instantiate)
- [Quick selection guide](#quick-selection-guide)
- [Module index](#module-index)
- [Inline patterns (no dedicated macro cell)](#inline-patterns-no-dedicated-macro-cell)

---

## Agent rule: ask before instantiate

When the task matches a row in the **Quick selection guide** or **Module index** (or the user’s macro doc):

1. **Tell the user** which library macro(s) fit and why (one sentence).
2. **Ask:** use the **library macro** (instantiate `km_hssi_*` / documented cell) or **custom inline** RTL?
3. **Do not** silently instantiate a library macro or write bespoke 2-flop/sync logic without that confirmation — unless the user already said “use `km_hssi_bitsync`” (or named another macro) in the same thread.

If the user declines the macro, use [cdc-reusable-patterns.md](cdc-reusable-patterns.md) only as **reference patterns**, not as a mandate to copy module names.

---

## Quick selection guide

From [cdc-reusable-patterns.md §7](cdc-reusable-patterns.md#7-selection-guide):

| Scenario | Library macro / pattern | Example inst. |
|----------|-------------------------|---------------|
| 1-bit flag/enable CDC | `km_hssi_bitsync` | [km_hssi_bitsync_inst.sv](../examples/cdc/km_hssi_bitsync_inst.sv) |
| 1-bit critical / higher MTBF | `km_hssi_bitsync3` | [bitsync3_inst.sv](../examples/cdc/bitsync3_inst.sv) |
| 1-bit PPS / tick / edge | Toggle/edge pattern (§1.3) | [toggle_edge_detector.sv](../examples/cdc/toggle_edge_detector.sv) |
| Single-cycle pulse CDC | `km_hssi_pulse_cross` | [pulse_cross_inst.sv](../examples/cdc/pulse_cross_inst.sv) |
| Multi-bit slow config (auto) | `km_hssi_vecsync_cdc` or `km_hssi_vecsync` | [vecsync_cdc_inst.sv](../examples/cdc/vecsync_cdc_inst.sv) |
| Multi-bit + backpressure | `km_hssi_vecsync_handshake` | — (see design doc §2.3) |
| Per-bit level + handshake | `km_hssi_lvlsync` | — (see design doc §2.5) |
| Streaming async CDC | `km_hssi_async_fifo` | [async_fifo_inst.sv](../examples/cdc/async_fifo_inst.sv) |
| Async reset → sync domain | `km_hssi_altr_hps_rstnsync` | — (see design doc §4.1) |
| Gray pointer helpers | `km_hssi_bintogray`, `km_hssi_graytobin` | [gray_*.sv](../examples/cdc/) |

**Do not** use `km_hssi_bitsync` on multi-bit buses. Use handshake, FIFO, or gray FIFO pointers per [cdc-crossings.md](../standards/cdc-crossings.md).

---

## Module index

| Macro module | Category | Design doc section | Keywords |
|--------------|----------|-------------------|----------|
| `km_hssi_bitsync` | Bit sync | §1.1 | bitsync, 2ff, bit synchronizer |
| `km_hssi_bitsync3` | Bit sync (MTBF) | §1.2 | bitsync3, 3-flop, mtbf |
| `km_hssi_pulse_cross` | Pulse CDC | §2.4 | pulse cross, pulse cdc |
| `km_hssi_vecsync_cdc` | Vector CDC | §2.1 | vecsync_cdc, auto detect |
| `km_hssi_vecsync` | Vector CDC | §2.2 | vecsync restricted |
| `km_hssi_vecsync_handshake` | Vector CDC | §2.3 | vecsync handshake, load_data |
| `km_hssi_lvlsync` | Level sync | §2.5 | lvlsync |
| `km_hssi_async_fifo` | FIFO | §6 | async fifo, streaming |
| `km_hssi_altr_hps_rstnsync` | Reset | §4.1 | aasd, reset sync |
| `km_hssi_bintogray` | Gray | §5.1 | bintogray |
| `km_hssi_graytobin` | Gray | §5.2 | graytobin |

**Typical RTL path (reference):** `km_xcvr_common/src/rtl/km_xcvr_common/cdc/...` — confirm in your project tree before instantiation.

---

## Inline patterns (no dedicated macro cell)

Use **inline RTL** (or project-specific modules) when the user rejects library macros or no macro fits:

| Pattern | Design doc | Example |
|---------|------------|---------|
| Sample-and-hold on tick | §3.1 | [sample_and_hold_period.sv](../examples/latching/sample_and_hold_period.sv) |
| Coherent status snapshot | §3.2 | [coherent_status_snapshot.sv](../examples/latching/coherent_status_snapshot.sv) |
| Tick pipeline | §3.3 | [tick_pipeline.sv](../examples/latching/tick_pipeline.sv) |
| Init pipeline | §4.2 | [init_pipeline_3stage.sv](../examples/resets/init_pipeline_3stage.sv) |
| Generic 2-flop teaching | — | [sync_2ff.sv](../examples/cdc/sync_2ff.sv) |
