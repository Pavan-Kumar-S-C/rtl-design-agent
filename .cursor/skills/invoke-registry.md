# RTL Design Agent — invoke registry

**Maintainer:** add a row when you add a new skill. `@help` reads this file verbatim for users.

| Invoke | Also known as | What it does when invoked |
|--------|---------------|---------------------------|
| `@help` | `help` | Lists all invoke names and descriptions (this table). |
| `@rtl-design` | `@rtl-coding-standards` | Write, review, and refactor Verilog/SystemVerilog RTL; HAS/MAS lifecycle. FSM, CDC RTL, clocks/resets, CSR, macros. **Does not** load Timing Analyzer UG, Cookbook, SpyGlass CDC/Lint, or `examples/sdc/`. |
| `@timing-analysis` | — | STA and timing reports: Timing Analyzer UG (Ch.1 + §2.1/2.5/2.7), Quartus §3 MTBF reporting, `metastability-mtbf.md`, UG-linked `examples/sdc/` for context. Router: [timing-analysis/topic-router.md](timing-analysis/topic-router.md). Does **not** author `.sdc` — use `@sdc`. |
| `@sdc` | — | SDC authoring/review: Timing Analyzer **Cookbook** (all recipe sections), UG §2.6.x constraints, full `docs/examples/sdc/` (14 templates). Router: [sdc/topic-router.md](sdc/topic-router.md). Does **not** interpret reports — use `@timing-analysis`. |
| `@cdc` | — | VC SpyGlass CDC verification (FPGA): `cdc_setup`, `cdc_setup_check`, `cdc_reset_integrity`, `cdc_verify`, `cdc_abstract`, `cdc_verify_struct`. Router: [cdc/topic-router.md](cdc/topic-router.md). Does **not** write synchronizer RTL — use `@rtl-design`. |
| `@lint` | — | VC SpyGlass Lint for FPGA: `lint_rtl` / `block/initial_rtl`, synthesizability, connectivity, structure. Router: [lint/topic-router.md](lint/topic-router.md). Does **not** run CDC checks — use `@cdc`. |
| `@testbench` | `tb` | Generate complete self-checking Verilog/SystemVerilog testbenches for a module or full DUT/top: **functional (positive) tests** and **negative tests** per MAS assumptions/failure IDs. Router: [testbench/topic-router.md](testbench/topic-router.md). Does **not** write DUT RTL — use `@rtl-design`. |

## Quick picker

| Your task | Invoke |
|-----------|--------|
| List what is available | `@help` |
| Write/review RTL, HAS/MAS lifecycle | `@rtl-design` |
| Understand timing reports, STA concepts, slack, MTBF | `@timing-analysis` |
| Write or fix `.sdc` constraint files | `@sdc` |
| SpyGlass CDC setup, verify, reset, struct, SAM | `@cdc` |
| SpyGlass Lint violations on FPGA RTL | `@lint` |
| Self-checking simulation testbench | `@testbench` |
