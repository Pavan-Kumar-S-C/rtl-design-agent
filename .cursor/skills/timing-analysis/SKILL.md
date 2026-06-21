---
name: timing-analysis
description: >-
  Static timing analysis (STA) and Timing Analyzer reports for Intel/Altera
  Quartus. Setup, hold, slack, multicycle concepts, report_timing, report_fmax,
  report_metastability, MTBF reporting, CDC timing analysis. Invoke
  @timing-analysis. For writing SDC constraint files use @sdc; for RTL use
  @rtl-design.
disable-model-invocation: true
---

# Timing Analysis

**Invoke:** `@timing-analysis`

**Not this skill:** SDC authoring → `@sdc`. RTL / CDC primitives → `@rtl-design`. List invokes → `@help`.

## What this skill covers (moved from @rtl-design)

All **STA and timing-report** work that previously lived under `@rtl-design` / `topics/timing-analyzer.md`:

- Timing path / clock / slack concepts (UG Ch.1)
- Setup, hold, recovery, removal, multicycle **analysis** concepts
- Timing Analyzer flow and **report catalog** (`report_timing`, `report_fmax`, `report_clock_transfers`, `report_metastability`, CDC viewer, bottlenecks)
- Quartus **MTBF reporting** and metastability analysis (Design Recommendations §3.2–3.5)
- Tcl/collections for **reading** timing (`quartus_sta`, `get_clocks`, `get_registers`)
- How existing `.sdc` affects reported timing (read UG examples for context — do not author new constraints here)

## Procedure

Follow [topic-router.md](topic-router.md) — selective load only; **one** UG or Quartus `##` section per task.

1. [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) — Timing Analyzer UG, Metastability/MTBF, Quartus STA rows
2. Matched section of [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md)
3. When MTBF / `report_metastability`: [quartus-design-recommendations.md](../../../docs/standards/quartus-design-recommendations.md) §3.x + [metastability-mtbf.md](../../../docs/standards/metastability-mtbf.md)
4. UG-linked [docs/examples/sdc/](../../../docs/examples/sdc/) files when explaining constraint impact on reports

**Never load** [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md) for recipe authoring — that is `@sdc`.

**PDFs:** [Timing Analyser UG.pdf](../../../docs/standards/Timing%20Analyser%20UG.pdf), [Design Recommendations.pdf](../../../docs/standards/Design%20Recommendations.pdf) — opt-in verbatim only.

## Conduct

- Base answers on standards + user reports / open `.sdc` context. **Do not invent** clocks, periods, or slack.
- **Ask** when report type, device family, or clock names are missing.
- **Quartus fit/STA:** run fitter, STA, or read timing `.rpt` **only** when the user explicitly asks ([quartus-module-build.md](../../../docs/standards/quartus-module-build.md)). Use workspace `.qpf` + **qshell**/PATH; do not create `quartus/module_build/` by default.
- Separate facts from recommendations; cite UG or Quartus section used.

## Related invokes

| Task | Invoke |
|------|--------|
| Write/review `.sdc` | `@sdc` |
| RTL synchronizer attributes, CDC RTL | `@rtl-design` |
| List all features | `@help` |

## Maintainer

- UG section router: [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) + [topic-router.md](topic-router.md)
- Examples: [docs/examples/sdc/README.md](../../../docs/examples/sdc/README.md) (UG rows only)
