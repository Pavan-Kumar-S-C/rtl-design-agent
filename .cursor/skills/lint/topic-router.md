# Topic router — @lint

## Rule: spyglass summary + company synth rules; one section at a time

1. Use [spyglass-lint-fpga.md](../../../docs/standards/spyglass-lint-fpga.md), [synthesizability-lint.md](../../../docs/standards/synthesizability-lint.md), user violation tags, and RTL.
2. Read **one** section per task — do not load full PDF or entire summary at once.
3. **Do not invent** tag names or waiver rationale.
4. FPGA default goal is **`lint_rtl`** — not `lint_rtl_enhanced` unless user explicitly runs enhanced sign-off.
5. **Do not** load SpyGlass CDC docs — redirect to `@cdc`.

## Step 1 — Classify topic

| User keywords | Load section |
|---------------|--------------|
| lint setup, enable_lint, check_lint, configure_lint_setup, initial_rtl, block/initial_rtl | FPGA flow + Recommended FPGA flow |
| latch, inferred latch, incomplete assignment | Rule categories → Latch + [synthesizability-lint.md](../../../docs/standards/synthesizability-lint.md) |
| unsynth, #delay, initial block, synthesizable | Synthesizability category |
| multiple driver, combinational loop, floating, width mismatch | Structure / Connectivity |
| sensitivity, blocking, non-blocking, race, sim hang | Simulation quality |
| lint_clk_rst, clock on latch, pad clock | FPGA-relevant application variables |
| configure_lint_tag, disable tag, W415 | Tag configuration |
| lint_synth, gate sim mismatch | Optional lint_synth (note: netlist phase) |

## Step 2 — Load docs

| Match | Load |
|-------|------|
| Any SpyGlass lint task | [spyglass-lint-fpga.md](../../../docs/standards/spyglass-lint-fpga.md) — **one** `##` section |
| RTL fix guidance | [synthesizability-lint.md](../../../docs/standards/synthesizability-lint.md) + [docs/examples/comb/](../../../docs/examples/comb/) |
| Reset-related lint | [clocks-resets.md](../../../docs/standards/clocks-resets.md) |

## Step 3 — PDF (opt-in)

[vc_spyglass_lint_userguide.pdf](../../../docs/standards/vc_spyglass_lint_userguide.pdf):

| PDF chapter | When |
|-------------|------|
| Ch. 3 | `check_lint` flow |
| Ch. 4 | Goals, `lint_rtl`, methodologies |
| Ch. 5 | Application variables (`lint_clk_rst_*`) |
| Tag reference | Specific tag ID from user report |

Raw extract: [_spyglass_lint_extract_raw.txt](../../../docs/standards/_spyglass_lint_extract_raw.txt) — partial.

## Redirects

| User intent | Invoke |
|-------------|--------|
| CDC crossing / SETUP_* / CDC_UNSYNC | `@cdc` |
| General RTL review without SpyGlass | `@rtl-design` |
