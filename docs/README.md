# RTL documentation index

## Invoke skills

| Invoke | Skill | Router |
|--------|-------|--------|
| `@help` | [.cursor/skills/help/](../.cursor/skills/help/) | [invoke-registry.md](../.cursor/skills/invoke-registry.md) |
| `@rtl-design` | RTL + lifecycle | [rtl-design/topic-router.md](../.cursor/skills/rtl-design/topic-router.md) |
| `@timing-analysis` | STA / timing reports | [timing-analysis/topic-router.md](../.cursor/skills/timing-analysis/topic-router.md) |
| `@sdc` | SDC constraints | [sdc/topic-router.md](../.cursor/skills/sdc/topic-router.md) |
| `@cdc` | SpyGlass CDC verification | [cdc/topic-router.md](../.cursor/skills/cdc/topic-router.md) |
| `@lint` | SpyGlass Lint (FPGA) | [lint/topic-router.md](../.cursor/skills/lint/topic-router.md) |
| `@testbench` | Self-checking testbenches — functional + negative (MAS assumptions/failures) | [testbench/topic-router.md](../.cursor/skills/testbench/topic-router.md) |

Registry: [.cursor/skills/invoke-registry.md](../.cursor/skills/invoke-registry.md)

## How the agent reads docs

1. **Never loads everything** — matches your words to topics in [standards/INDEX.md](standards/INDEX.md).
2. **Design guides** — reads only the **Content** section you register in [design/INDEX.md](design/INDEX.md).
3. Uses **coding guidelines + your input**; **asks you only when in doubt** (not on every task).

**PDFs:** optional — slim clone excludes `docs/standards/*.pdf` (~69 MB). See [standards/PDFs-README.md](standards/PDFs-README.md). Agent uses `.md` summaries; PDFs are opt-in verbatim only.

## Standards (by topic)

Router: [standards/INDEX.md](standards/INDEX.md) — **canonical** keyword → file map.

| File | Topic |
|------|--------|
| [verilog-systemverilog-dialect.md](standards/verilog-systemverilog-dialect.md) | Dialect |
| [synthesizability-lint.md](standards/synthesizability-lint.md) | Synth / lint |
| [clocks-resets.md](standards/clocks-resets.md) | Clocks / resets |
| [cdc-crossings.md](standards/cdc-crossings.md) | CDC RTL patterns |
| [spyglass-cdc-fpga.md](standards/spyglass-cdc-fpga.md) | SpyGlass CDC index — invoke **`@cdc`** |
| [spyglass-cdc/](standards/spyglass-cdc/) | Per-goal CDC files (`cdc_setup`, `cdc_verify`, …) |
| [spyglass-lint-fpga.md](standards/spyglass-lint-fpga.md) | SpyGlass Lint — invoke **`@lint`** |
| [testbench-generation.md](standards/testbench-generation.md) | Testbench — invoke **`@testbench`** |
| [metastability-mtbf.md](standards/metastability-mtbf.md) | Metastability / MTBF bridge |
| [quartus-design-recommendations.md](standards/quartus-design-recommendations.md) | Quartus RTL + metastability |
| [quartus-module-build.md](standards/quartus-module-build.md) | Module Quartus build (Standard) — workspace `.qpf` + qshell, opt-in |
| [timing-analyzer-ug.md](standards/timing-analyzer-ug.md) | Timing Analyzer / STA concepts — invoke **`@timing-analysis`** (reports) or **`@sdc`** (§2.6.x constraints) |
| [timing-analyzer-cookbook.md](standards/timing-analyzer-cookbook.md) | SDC recipes — invoke **`@sdc`** |
| [megafunctions-ip-cores.md](standards/megafunctions-ip-cores.md) | IP Catalog / megafunctions |
| [rtl-macros.md](standards/rtl-macros.md) | RTL macros / library vs IP |
| [fsm-coding.md](standards/fsm-coding.md) | FSM |
| [mas-rtl-workflow.md](standards/mas-rtl-workflow.md) | HAS→MAS→RTL, port naming, debug logic |
| [csr-registers.md](standards/csr-registers.md) | CSR |
| [ct22-security-debug.md](standards/ct22-security-debug.md) | CT22 |
| [review-workflow.md](standards/review-workflow.md) | Review flow |
| [rtl-database-schema.md](standards/rtl-database-schema.md) | RTL database schema (requirements / modules / register index / traceability) |

Legacy index stub: [rtl-coding-standards.md](standards/rtl-coding-standards.md) → use INDEX.md.

**PDFs (opt-in verbatim):** under `standards/` — Design Recommendations, Timing Analyser UG, Timing Cookbook, megafunctions UG, VC SpyGlass CDC/Lint UGs.

## Your design documents

| File | Role |
|------|------|
| [design/cdc-reusable-patterns.md](design/cdc-reusable-patterns.md) | CDC / handshake / FIFO / latching / reset patterns |
| [design/architecture-comparison.md](design/architecture-comparison.md) | Legacy vs new ToD architecture |
| [design/km-xcvr-tod-analysis.md](design/km-xcvr-tod-analysis.md) | km_xcvr ToD sync analysis |
| [design/legacy-tod-sync-analysis.md](design/legacy-tod-sync-analysis.md) | Legacy ToD synchronizer CDC |
| [design/rtl-macro-library.md](design/rtl-macro-library.md) | `km_hssi_*` macro catalog |

Router: [design/INDEX.md](design/INDEX.md) — read **one section at a time** by keyword match.

## Development & verification lifecycle

The agent also runs a HAS/MAS → RTL database → gated generation → traceability lifecycle:

- Workflow: [.cursor/skills/rtl-design/dev-verify-workflow.md](../.cursor/skills/rtl-design/dev-verify-workflow.md)
- Schema: [standards/rtl-database-schema.md](standards/rtl-database-schema.md)
- Templates: [templates/rtl-db/](../templates/rtl-db/) (YAML DB + JSON Schema + report skeletons) and [templates/project-layout/](../templates/project-layout/) (new-project scaffold)

## Examples

Golden patterns: [examples/](examples/) — CDC, latching, resets, FSM, comb, dialect. **SDC:** [examples/sdc/](examples/sdc/) — invoke **`@sdc`** (authoring) or **`@timing-analysis`** (UG-linked context for reports).

## Coverage matrix

[COVERAGE.md](COVERAGE.md) — doc section → INDEX → skill topic → example status.

## Maintainer

- New rule topic → new `standards/<topic>.md` + INDEX row + optional `topics/<topic>.md` skill stub.
- Update [COVERAGE.md](COVERAGE.md) when adding sections or examples.
- Copy coding examples from design doc **Content** sections into `examples/<topic>/`.
