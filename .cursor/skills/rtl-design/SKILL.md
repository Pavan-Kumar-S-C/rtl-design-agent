---
name: rtl-design
description: >-
  Write, review, and refactor Verilog/SystemVerilog RTL, and run the RTL
  development & verification lifecycle (HAS/MAS requirements, RTL database,
  gap analysis, gated generation, traceability). FSM, CDC, resets, lint, CSR,
  macros. Invoke @rtl-design. For STA reports use @timing-analysis; for SDC
  files use @sdc; for SpyGlass CDC use @cdc; for SpyGlass Lint use @lint;
  for testbenches use @testbench; for all invokes type @help.
disable-model-invocation: true
---

# RTL Design Agent

**Invoke:** `@rtl-design` (alias: `@rtl-coding-standards`)

**Other invokes:** `@timing-analysis` · `@sdc` · `@cdc` · `@lint` · `@testbench` · `@help`

## Two modes

- **Coding mode** (default) — write / review / refactor RTL. Use the read order below and [design-workflow.md](design-workflow.md) / [review-checklist.md](review-checklist.md).
- **Lifecycle mode** — when the prompt is about **requirements, RTL database, traceability, gap analysis, generate-from-spec, or verify-against-spec**. Run [dev-verify-workflow.md](dev-verify-workflow.md): start with **workspace assessment**, then follow the gated decision flow (generate RTL only from a validated database). Lifecycle keywords: `has`, `mas`, `requirement`, `rtl database`, `rtl_db`, `traceability`, `gap analysis`, `coverage`, `generate from spec`, `verify rtl`. See [topic-router.md](topic-router.md) for routing. Coding-standards loading still applies during generation.

## Guidelines + user input; ask when in doubt

- Use **coding guidelines** (`docs/standards/`) and **user input** (prompt, open RTL, stated spec).
- Match [topic-router.md](topic-router.md) keywords when possible; on **no match**, follow the router **fallback** (baseline guidelines, do not block the task).
- **Ask the user** only when you have **doubts** — missing dialect, unclear scope/intent, or spec gaps that would make the answer wrong. Do **not** invent ports, clocks, resets, or register maps.

## Read order (selective — not everything)

**Hard block:** follow [rtl-design-exclusions.md](rtl-design-exclusions.md) — never load Timing Analyzer, Cookbook, SpyGlass CDC/Lint, testbench-generation, or `examples/sdc/`. Redirect to `@timing-analysis` / `@sdc` / `@cdc` / `@lint` / `@testbench`.

Follow [topic-router.md](topic-router.md):

1. [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) — match keywords → topic list
2. **Only** matched [docs/standards/<topic>.md](../../../docs/standards/) files — **never** [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md) or [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md) (see [rtl-design-exclusions.md](rtl-design-exclusions.md))
3. **Only** matched sections from [docs/design/INDEX.md](../../../docs/design/INDEX.md) (user design docs)
4. **Only** matched [docs/examples/](../../../docs/examples/) for those topics — **never** [examples/sdc/](../../../docs/examples/sdc/)
5. [design-workflow.md](design-workflow.md) or [review-checklist.md](review-checklist.md) if write vs review intent is clear; else **ask**

**Never** read all files under `docs/standards/` in one turn.

## Topic skill stubs

Optional one-screen pointers: [topics/](topics/) (fsm, cdc, clocks-resets, dialect, synthesizability, structure, mas-rtl, csr, ct22, quartus-metastability, quartus-module-build, rtl-macros, requirements, rtl-database, traceability).

**Timing / SDC / SpyGlass / TB:** use separate invokes — `@timing-analysis`, `@sdc`, `@cdc`, `@lint`, `@testbench` (see [invoke-registry.md](../invoke-registry.md)).

**Lifecycle:** [dev-verify-workflow.md](dev-verify-workflow.md) + schema [docs/standards/rtl-database-schema.md](../../../docs/standards/rtl-database-schema.md) + [templates/rtl-db/](../../../templates/rtl-db/).

**Quartus (module build):** [quartus-module-build.md](../../../docs/standards/quartus-module-build.md) — **opt-in only**; use workspace RTL + existing `.qpf`, **qshell**/PATH for commands; no default `quartus/module_build/`. Synthesis → `@rtl-design`; fit/STA → `@timing-analysis`; `.sdc` → `@sdc`.

**Macros:** [megafunctions-ip-cores.md](../../../docs/standards/megafunctions-ip-cores.md) (IP Catalog / **ug_intro_to_megafunctions**) and [rtl-macro-library.md](../../../docs/design/rtl-macro-library.md) (`km_hssi_*`) — **ask the user** before using IP or library macro (conduct rule). 

**Coverage matrix:** [docs/COVERAGE.md](../../../docs/COVERAGE.md)

## Behavior

- Synthesizable RTL unless user requests TB-only constructs.
- Match project Verilog vs SystemVerilog dialect from open files.
- Facts vs recommendations; cite which standard file applied.
- PDFs opt-in only.

## Maintainer

- Split rules: `docs/standards/<topic>.md` + row in INDEX.md
- Design docs: `docs/design/` + section rows in `docs/design/INDEX.md`
- Examples: `docs/examples/<topic>/`
