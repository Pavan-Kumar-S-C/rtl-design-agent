# RTL documentation index

## How the agent reads docs

1. **Never loads everything** — matches your words to topics in [standards/INDEX.md](standards/INDEX.md).
2. **Design guides** — reads only the **Content** section you register in [design/INDEX.md](design/INDEX.md).
3. Uses **coding guidelines + your input**; **asks you only when in doubt** (not on every task).

## Standards (by topic)

Router: [standards/INDEX.md](standards/INDEX.md)

| File | Topic |
|------|--------|
| [verilog-systemverilog-dialect.md](standards/verilog-systemverilog-dialect.md) | Dialect |
| [synthesizability-lint.md](standards/synthesizability-lint.md) | Synth / lint |
| [clocks-resets.md](standards/clocks-resets.md) | Clocks / resets |
| [cdc-crossings.md](standards/cdc-crossings.md) | CDC |
| [fsm-coding.md](standards/fsm-coding.md) | FSM |
| [constants-structure.md](standards/constants-structure.md) | Parameters / structure |
| [csr-registers.md](standards/csr-registers.md) | CSR |
| [ct22-security-debug.md](standards/ct22-security-debug.md) | CT22 |
| [review-workflow.md](standards/review-workflow.md) | Review flow |

Legacy index stub: [rtl-coding-standards.md](standards/rtl-coding-standards.md) → use INDEX.md.

## Your design documents

| File | Role |
|------|------|
| [design/cdc-reusable-patterns.md](design/cdc-reusable-patterns.md) | CDC / handshake / FIFO / latching / reset patterns |
| [design/architecture-comparison.md](design/architecture-comparison.md) | Legacy vs new ToD architecture |
| [design/km-xcvr-tod-analysis.md](design/km-xcvr-tod-analysis.md) | km_xcvr ToD sync analysis |

Router: [design/INDEX.md](design/INDEX.md) — read **one section at a time** by keyword match.

## Examples

Golden patterns: [examples/](examples/) (fsm, cdc, resets, comb, dialect).

## Maintainer

- New rule topic → new `standards/<topic>.md` + INDEX row + optional `topics/<topic>.md` skill stub.
- Copy coding examples from your design doc **Content** sections into `examples/<topic>/`.
