# RTL examples (from your design documents)

Extracted from [docs/design/](../design/). The agent loads **only** files for topics matched to the user prompt.

## CDC and sync — [cdc/](cdc/)

| File | Source section |
|------|----------------|
| `toggle_edge_detector.sv` | cdc-reusable-patterns §1.3 |
| `km_hssi_bitsync_inst.sv` | cdc-reusable-patterns §1.1 |
| `bitsync3_inst.sv` | cdc-reusable-patterns §1.2 (MTBF) |
| `synchronizer_attributes.sv` | quartus-design-recommendations §3.4.2, architecture §4 |
| `vecsync_cdc_inst.sv` | cdc-reusable-patterns §2.1 |
| `pulse_cross_inst.sv` | cdc-reusable-patterns §2.4 |
| `async_fifo_inst.sv` | cdc-reusable-patterns §6 |
| `km_xcvr_tick_detect.sv` | km-xcvr-tod-analysis §2.1 |
| `legacy_tod_toggle_detect.v` | architecture-comparison §2 |
| `gray_bintogray.sv` / `gray_graytobin.sv` | cdc-reusable-patterns §5 |
| `sync_2ff.v` / `sync_2ff.sv` | Generic 2-flop (teaching) |

## Latching / pipelines — [latching/](latching/)

| File | Source section |
|------|----------------|
| `sample_and_hold_period.sv` | cdc-reusable-patterns §3.1 |
| `coherent_status_snapshot.sv` | cdc-reusable-patterns §3.2 |
| `tick_pipeline.sv` | cdc-reusable-patterns §3.3 |

## Resets — [resets/](resets/)

| File | Source section |
|------|----------------|
| `init_pipeline_3stage.sv` | cdc-reusable-patterns §4.2 |
| `sync_reset_release.sv` | Generic AASD companion pattern |

## SDC / STA — [sdc/](sdc/)

Full catalog: [sdc/README.md](sdc/README.md) (14 teaching `.sdc` files — Timing Analyzer UG + Cookbook).

| File | Source |
|------|--------|
| `initial_dual_clock.sdc` | Timing Analyzer UG §2.6.1 |
| `cdc_async_bus.sdc` | Timing Analyzer UG §2.6.5.7 |
| `multicycle_setup_hold.sdc` | Timing Analyzer UG §2.6.8.4.2 |
| `generated_clock_mux.sdc` | Timing Analyzer UG §2.6.5.3.2 |
| `duty_cycle_6040.sdc` | Timing Cookbook |
| `clock_offset.sdc` | Timing Cookbook |
| `pll_derive_clocks.sdc` | Timing Cookbook |
| `external_switched_clock.sdc` | Timing Cookbook |
| `virtual_io_chip_to_chip.sdc` | Timing Cookbook |
| `io_tsu_th_tco.sdc` | Timing Cookbook |
| `multicycle_clk_to_clk.sdc` | Timing Cookbook |
| `false_path_clk_to_clk.sdc` | Timing Cookbook |
| `clock_enable_multicycle.sdc` | Timing Cookbook |
| `jtag_constraints_stub.sdc` | Timing Cookbook (stub) |
| `dual_port_clock_io.sdc` | Timing Cookbook (stub) |

## FSM / comb / dialect — [fsm/](fsm/) · [comb/](comb/) · [dialect/](dialect/)

Generic teaching patterns (not from design docs). Prefer design-doc examples when the task is CDC/ToD.

## Usage

```text
@rtl-design Implement tick detect like docs/examples/cdc/km_xcvr_tick_detect.sv
```
