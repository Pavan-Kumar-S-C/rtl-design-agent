# Clocks and resets

**Keywords:** `clock`, `clk`, `reset`, `rst`, `rst_n`, `async`, `sync`, `posedge`, `negedge`, `reset synchronizer`

- **Sequential blocks:** clock with **synchronous reset** style where project convention uses `posedge clk` and reset sampled on clock edge (e.g. `posedge clk` + sync `rst_n` deassert synchronized).
- **Asynchronous resets:** use active-high or active-low **consistently** within a block; document polarity at module boundary.
- **Reset synchronizers:** instantiate standard reset sync cells when crossing async reset into clock domains; do not release reset metastably.

**Design doc:** [cdc-reusable-patterns.md](../design/cdc-reusable-patterns.md) §4 — via [design/INDEX.md](../design/INDEX.md)

**Examples:** [docs/examples/resets/](../../examples/resets/)
