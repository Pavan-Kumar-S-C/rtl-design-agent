# Synthesizability and lint

**Keywords:** `synth`, `synthesizable`, `latch`, `lint`, `spyglass`, `verilator`, `combinational`, `initial`, `delay`, `#`

- Write **synthesizable** RTL only.
- **No inferred latches** in combinational logic — every `if`/`case` branch assigns all outputs; use explicit `default`.
- **No delay elements** (`#10`, `#1ns`) in synthesizable modules (testbenches only).
- Avoid **`initial` blocks for logic** — allowed only for simulation TB, parameter/assert checks in TB, or non-synth stubs clearly marked.
- No combinational loops; code must pass **SpyGlass / Verilator**-class lint.

**SpyGlass Lint flow:** invoke **`@lint`** — [spyglass-lint-fpga.md](spyglass-lint-fpga.md).

**Examples:** [docs/examples/comb/](../../examples/comb/)
