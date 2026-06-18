# SDC examples (Timing Analyzer UG + Cookbook)

Teaching templates — not project-specific sign-off constraints.

## Timing Analyzer UG (UG-20140)

| File | Source |
|------|--------|
| [initial_dual_clock.sdc](initial_dual_clock.sdc) | §2.6.1 Recommended initial SDC |
| [cdc_async_bus.sdc](cdc_async_bus.sdc) | §2.6.5.7 Constraining CDC paths |
| [multicycle_setup_hold.sdc](multicycle_setup_hold.sdc) | §2.6.8.4.2 Relaxing setup with multicycle |
| [generated_clock_mux.sdc](generated_clock_mux.sdc) | §2.6.5.3.2 Clock mux + exclusive groups |

## Timing Analyzer Cookbook (MNL-01035 / 683081)

| File | Cookbook topic |
|------|----------------|
| [duty_cycle_6040.sdc](duty_cycle_6040.sdc) | Non-50/50 duty cycle |
| [clock_offset.sdc](clock_offset.sdc) | Offset clocks |
| [pll_derive_clocks.sdc](pll_derive_clocks.sdc) | PLL method 2 |
| [external_switched_clock.sdc](external_switched_clock.sdc) | Externally switched clock (`-add`) |
| [virtual_io_chip_to_chip.sdc](virtual_io_chip_to_chip.sdc) | System synchronous input |
| [io_tsu_th_tco.sdc](io_tsu_th_tco.sdc) | tSU / tH / tCO |
| [multicycle_clk_to_clk.sdc](multicycle_clk_to_clk.sdc) | Multicycle clock-to-clock |
| [false_path_clk_to_clk.sdc](false_path_clk_to_clk.sdc) | False path clock-to-clock |
| [clock_enable_multicycle.sdc](clock_enable_multicycle.sdc) | Clock-enable multicycle + `get_fanouts` |
| [jtag_constraints_stub.sdc](jtag_constraints_stub.sdc) | JTAG minimal (full template in PDF) |
| [dual_port_clock_io.sdc](dual_port_clock_io.sdc) | Dual clock on one port (stub) |

Agent summaries: [timing-analyzer-ug.md](../../standards/timing-analyzer-ug.md) · [timing-analyzer-cookbook.md](../../standards/timing-analyzer-cookbook.md)

**Invokes:** UG examples + report context → **`@timing-analysis`**. All templates for authoring → **`@sdc`**. Routers: [timing-analysis/topic-router.md](../../../.cursor/skills/timing-analysis/topic-router.md) · [sdc/topic-router.md](../../../.cursor/skills/sdc/topic-router.md)

