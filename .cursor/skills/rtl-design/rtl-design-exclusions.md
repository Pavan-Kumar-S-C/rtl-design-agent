# @rtl-design — excluded topics (hard block)

When **`@rtl-design`** is active, **never** load the items below. If the user's prompt matches only these topics, **stop** and tell them to invoke **`@timing-analysis`**, **`@sdc`**, **`@cdc`**, **`@lint`**, or **`@testbench`** instead. Do **not** load those skill files as a substitute — ask the user to switch invoke.

## Blocked standard files

- [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md)
- [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md)
- Timing Analyzer / Cookbook **PDFs** under `docs/standards/`
- [spyglass-cdc-fpga.md](../../../docs/standards/spyglass-cdc-fpga.md) and [spyglass-cdc/](../../../docs/standards/spyglass-cdc/)
- [spyglass-lint-fpga.md](../../../docs/standards/spyglass-lint-fpga.md)
- [testbench-generation.md](../../../docs/standards/testbench-generation.md)
- VC SpyGlass CDC / Lint **PDFs** under `docs/standards/`
- SpyGlass raw extracts: `_spyglass_cdc_extract_raw.txt`, `_spyglass_lint_extract_raw.txt`

## Blocked examples

- Entire [docs/examples/sdc/](../../../docs/examples/sdc/) tree

## Blocked INDEX rows (do not match under @rtl-design)

From [docs/standards/INDEX.md](../../../docs/standards/INDEX.md):

- **Timing Analyzer / SDC**
- **Timing Analyzer Cookbook**
- **SpyGlass CDC**
- **SpyGlass Lint**
- **Testbench generation**

Keywords that would match those rows (`sdc`, `sta`, `check_cdc`, `check_lint`, `testbench`, `self-checking`, `uvm-lite`, `scoreboard`, etc.) → redirect, do not load.
## Allowed (RTL-side only)

These stay in scope for `@rtl-design` when keywords match — **RTL attribute / CDC logic**, not constraints or STA reports:

- [cdc-crossings.md](../../../docs/standards/cdc-crossings.md)
- [quartus-design-recommendations.md](../../../docs/standards/quartus-design-recommendations.md) — **RTL synchronizer attribute** sections only (not §3.2 MTBF reporting / Tcl scripting for reports)
- [metastability-mtbf.md](../../../docs/standards/metastability-mtbf.md) — RTL chain length / attribute guidance only
- [docs/examples/cdc/](../../../docs/examples/cdc/) — not `examples/sdc/`

For **`report_metastability`**, **`report_timing`**, slack analysis, or **writing `.sdc`** → user must invoke **`@timing-analysis`** or **`@sdc`**.

For **SpyGlass CDC goals** (`cdc_setup`, `cdc_verify`, `check_cdc`, `CDC_UNSYNC_*`, SAM) → **`@cdc`**.

For **SpyGlass Lint** (`check_lint`, `lint_rtl`, …) → **`@lint`**.

For **testbench generation** (self-checking sim TB, scoreboard, UVM-lite) → **`@testbench`**.

## Redirect message (use when blocked)

> This task is out of scope for `@rtl-design`. Use **`@timing-analysis`**, **`@sdc`**, **`@cdc`**, **`@lint`**, or **`@testbench`** as appropriate. Type **`@help`** to list all invokes.
