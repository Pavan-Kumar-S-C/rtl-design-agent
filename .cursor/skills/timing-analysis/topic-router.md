# Topic router — @timing-analysis

## Rule: standards + user input; ask only when in doubt

1. Use **Timing Analyzer UG**, **Quartus metastability/MTBF reporting** docs, and **user input** (reports, open `.sdc` for context, clock names).
2. **Do not** load every standards file — match keywords; read **one** `##` section at a time.
3. **Do not invent** clock names, periods, slack values, or board delays.
4. **Do not** load [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md) for SDC **authoring** — redirect to `@sdc`.
5. **Do not** load RTL CDC design docs for pure STA tasks — redirect to `@rtl-design` when the task is RTL primitive choice.

## Step 1 — Match INDEX rows

Read [docs/standards/INDEX.md](../../../docs/standards/INDEX.md). Match **only**:

| INDEX row | When |
|-----------|------|
| **Timing Analyzer / SDC** | STA, reports, slack, paths, `report_*`, Tcl analysis |
| **Metastability / MTBF** | MTBF, synchronizer chain analysis, toggle rate |
| **Quartus / Intel STA** | `report_metastability`, Quartus metastability flow, MTBF optimization |

**Skip:** Timing Analyzer **Cookbook** row → `@sdc`.

## Step 2 — Timing Analyzer UG (concepts + reports + analysis)

Source: [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md). Read **one** section when keywords match:

| Section | Keywords |
|---------|----------|
| 1.1 Timing paths and clocks | timing path, edge path, clock path, data path, unconstrained clock |
| 1.2 Setup, hold, recovery, removal | setup, hold, slack, recovery, removal, async reset timing |
| 1.2.5 Multicycle path analysis (concepts) | multicycle, setup end start, hold multicycle, phase shift |
| 1.2.6 Metastability analysis (concepts) | metastability analysis, mtbf timing analyzer |
| 1.2.7–1.2.10 Advanced analysis concepts | timing pessimism, clock-as-data, multicorner, time borrowing, hyperflex |
| 2.1 Timing Analyzer flow | run timing analyzer, timing flow, write sdc, sdc precedence |
| 2.5.1 Generating timing reports | report_timing, report_fmax, fmax summary, report_clock_transfers, report_metastability, cdc viewer, bottlenecks |
| 2.6.1 Recommended initial SDC | initial sdc concepts (read for **analysis context** only; authoring → `@sdc`) |
| 2.6.5.7 Constraining CDC paths | constrain cdc concepts, async bus analysis (authoring → `@sdc`) |
| 2.7 Tcl and collections | quartus_sta, report_timing tcl, get_registers, get_clocks, get_pins |

**UG examples** (read when explaining how constraints affect reported timing):

| File | UG section |
|------|------------|
| [initial_dual_clock.sdc](../../../docs/examples/sdc/initial_dual_clock.sdc) | §2.6.1 |
| [cdc_async_bus.sdc](../../../docs/examples/sdc/cdc_async_bus.sdc) | §2.6.5.7 |
| [multicycle_setup_hold.sdc](../../../docs/examples/sdc/multicycle_setup_hold.sdc) | §2.6.8.4.2 |
| [generated_clock_mux.sdc](../../../docs/examples/sdc/generated_clock_mux.sdc) | §2.6.5.3.2 |

Full catalog: [docs/examples/sdc/README.md](../../../docs/examples/sdc/README.md)

**Verbatim PDF:** [Timing Analyser UG.pdf](../../../docs/standards/Timing%20Analyser%20UG.pdf) — user requests full UG wording only.

## Step 3 — Quartus metastability / MTBF reporting

Source: [quartus-design-recommendations.md](../../../docs/standards/quartus-design-recommendations.md). For **@timing-analysis**, prefer reporting/analysis sections:

| Section | Keywords |
|---------|----------|
| 3. Managing metastability with Quartus Prime | quartus metastability, mtbf analysis |
| 3.1 Metastability analysis | synchronizer chain analysis |
| 3.2 Metastability and MTBF reporting | metastability report, mtbf summary, toggle rate 12.5 |
| 3.3 MTBF optimization | optimize for metastability, chain length |
| 3.5 Scripting (Tcl) | report_metastability, synchronizer_toggle_rate tcl |

Bridge: [metastability-mtbf.md](../../../docs/standards/metastability-mtbf.md)

**RTL synchronizer attributes** (`altera_attribute`, identify synchronizer on cells) → `@rtl-design` + [topics/quartus-metastability.md](../rtl-design/topics/quartus-metastability.md).

**Verbatim PDF:** [Design Recommendations.pdf](../../../docs/standards/Design%20Recommendations.pdf) — opt-in.

## Step 4 — Redirects

| User intent | Invoke |
|-------------|--------|
| Write/review `.sdc`, cookbook recipes | `@sdc` |
| RTL CDC primitives, synchronizer RTL | `@rtl-design` |
| List all features | `@help` |

## No INDEX match (fallback)

1. Apply UG §1.1–1.2 baseline (paths, setup/hold) + user report data.
2. Ask if clock names, device family, or report type are unclear.
3. Do not refuse solely because INDEX had no row.
