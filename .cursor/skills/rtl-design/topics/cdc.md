# Topic: CDC

**Load when keywords:** cdc, clock domain, crossing, synchronizer, 2ff, fifo, gray, metastable, vecsync, pulse cross, async fifo

**Standard:** [docs/standards/cdc-crossings.md](../../../../docs/standards/cdc-crossings.md)

**Also load when MTBF / Quartus / 3-flop:** [metastability-mtbf.md](../../../../docs/standards/metastability-mtbf.md), [quartus-design-recommendations.md](../../../../docs/standards/quartus-design-recommendations.md) (see [topics/quartus-metastability.md](quartus-metastability.md))

**Do not load under `@rtl-design`:** CDC SDC / STA → **`@timing-analysis`** or **`@sdc`**. SpyGlass CDC verification → **`@cdc`** ([rtl-design-exclusions.md](../rtl-design-exclusions.md)).

**Examples:** [docs/examples/cdc/](../../../../docs/examples/cdc/)

**Macros:** if task fits [rtl-macro-library.md](../../../../docs/design/rtl-macro-library.md) — see [topics/rtl-macros.md](rtl-macros.md); **ask** library macro vs inline before instantiate.

**Ask user if:** source/destination clocks or data width not stated; or macro vs custom logic when a catalog macro applies.
