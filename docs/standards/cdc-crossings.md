# Clock-domain crossings (CDC)

**Keywords:** `cdc`, `clock domain`, `crossing`, `synchronizer`, `2ff`, `two flop`, `metastable`, `mtbf`, `metastability`, `fifo`, `handshake`, `gray`, `vecsync`, `pulse cross`

- Explicitly **comment** every clock-domain crossing.
- Never mix unrelated clocks without synchronizers (2-flop for single bits, FIFO/handshake for buses).
- No logic combining unsynchronized signals from different domains.
- **MTBF / 3-flop / Quartus attributes:** [metastability-mtbf.md](metastability-mtbf.md) and [quartus-design-recommendations.md](quartus-design-recommendations.md) (match section in [INDEX.md](INDEX.md)).
- **SDC for CDC paths:** [timing-analyzer-ug.md §2.6.5.7](timing-analyzer-ug.md) — `set_clock_groups`, `set_max_skew`, `set_net_delay`; [cdc_async_bus.sdc](../examples/sdc/cdc_async_bus.sdc).
- **SDC recipes (mux, false path, async groups):** [timing-analyzer-cookbook.md](timing-analyzer-cookbook.md) — e.g. `set_clock_groups -exclusive`, false path clock-to-clock.

**Design doc (preferred):** [docs/design/cdc-reusable-patterns.md](../design/cdc-reusable-patterns.md) — match section via [design/INDEX.md](../design/INDEX.md)

**Library macros:** [rtl-macros.md](rtl-macros.md), [rtl-macro-library.md](../design/rtl-macro-library.md) — **ask user** before instantiating `km_hssi_*` unless already specified.

**Examples:** [docs/examples/cdc/](../../examples/cdc/) · [docs/examples/latching/](../../examples/latching/)
