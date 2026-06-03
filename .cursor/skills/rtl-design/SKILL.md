---
name: rtl-design
description: >-
  Write, review, and refactor Verilog/SystemVerilog RTL. Loads only topic-matched
  standards from docs/standards/ (FSM, CDC, resets, lint, etc.). Invoke
  @rtl-design. Uses coding guidelines + user input; asks only when in doubt. Alias:
  @rtl-coding-standards.
disable-model-invocation: true
---

# RTL Design Agent

**Invoke:** `@rtl-design`

## Guidelines + user input; ask when in doubt

- Use **coding guidelines** (`docs/standards/`) and **user input** (prompt, open RTL, stated spec).
- Match [topic-router.md](topic-router.md) keywords when possible; on **no match**, follow the router **fallback** (baseline guidelines, do not block the task).
- **Ask the user** only when you have **doubts** — missing dialect, unclear scope/intent, or spec gaps that would make the answer wrong. Do **not** invent ports, clocks, resets, or register maps.

## Read order (selective — not everything)

Follow [topic-router.md](topic-router.md):

1. [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) — match keywords → topic list
2. **Only** matched [docs/standards/<topic>.md](../../../docs/standards/) files (including **Quartus / MTBF:** [quartus-design-recommendations.md](../../../docs/standards/quartus-design-recommendations.md), [metastability-mtbf.md](../../../docs/standards/metastability-mtbf.md); **STA / SDC concepts:** [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md); **SDC recipes:** [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md))
3. **Only** matched sections from [docs/design/INDEX.md](../../../docs/design/INDEX.md) (user design docs)
4. **Only** matched [docs/examples/](../../../docs/examples/) for those topics
5. [design-workflow.md](design-workflow.md) or [review-checklist.md](review-checklist.md) if write vs review intent is clear; else **ask**

**Never** read all files under `docs/standards/` in one turn.

## Topic skill stubs

Optional one-screen pointers: [topics/](topics/) (fsm, cdc, clocks-resets, dialect, synthesizability, structure, csr, ct22, quartus-metastability, timing-analyzer, rtl-macros).

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
