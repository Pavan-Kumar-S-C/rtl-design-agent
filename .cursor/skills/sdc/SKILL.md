---
name: sdc
description: >-
  Author and review SDC timing constraint files for Intel/Altera Quartus.
  create_clock, set_input_delay, set_output_delay, false paths, multicycle,
  PLL derive, virtual clocks, JTAG, CDC constraints, cookbook recipes. Invoke
  @sdc. For STA report interpretation use @timing-analysis; for RTL use
  @rtl-design.
disable-model-invocation: true
---

# SDC Constraints

**Invoke:** `@sdc`

**Not this skill:** STA report interpretation → `@timing-analysis`. RTL design → `@rtl-design`. List invokes → `@help`.

## What this skill covers (moved from @rtl-design)

All **SDC constraint authoring and review** that previously lived under `@rtl-design` / `topics/timing-analyzer.md`:

- **Cookbook recipes** — clocks (duty cycle, offset, PLL, mux), I/O (virtual clock, chip-to-chip, tSU/tH/tCO, system synchronous), exceptions (multicycle, false path), JTAG
- **UG constraint sections** — §2.6.1 initial SDC, §2.6.5 clocks, §2.6.5.7 CDC paths, §2.6.6 I/O, §2.6.7 delay/skew, §2.6.8 exceptions and precedence
- **Golden examples** — full [docs/examples/sdc/](../../../docs/examples/sdc/) catalog (14 templates)

## Procedure

Follow [topic-router.md](topic-router.md) — selective load; **one** cookbook or UG `##` section per task.

1. [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) — Cookbook row (+ UG §2.6.x when precedence/CDC/clocks needed)
2. Matched section of [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md)
3. Matched UG §2.6.x from [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md) when authoring needs precedence or CDC syntax
4. Adapt from [docs/examples/sdc/](../../../docs/examples/sdc/) — see [README](../../../docs/examples/sdc/README.md)

**Do not** load UG Ch.1 or §2.5.1 report catalog for pure SDC tasks — `@timing-analysis`.

**PDF:** [Timing analyser CookBook.pdf](../../../docs/standards/Timing%20analyser%20CookBook.pdf) — opt-in (JTAG Example 21 Tcl).

## Conduct

- **Do not invent** clock names, periods, board delays, or ports — use user `.sdc`, RTL, or datasheet; ask when missing.
- Match open project `.sdc` style and clock names.
- Cite cookbook example or UG section for every recommended constraint.
- Separate facts from recommendations.

## Related invokes

| Task | Invoke |
|------|--------|
| Timing reports, slack, MTBF analysis | `@timing-analysis` |
| RTL / CDC crossing review | `@rtl-design` |
| List all features | `@help` |

## Maintainer

- Cookbook router: [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) + [topic-router.md](topic-router.md)
- Examples: [docs/examples/sdc/README.md](../../../docs/examples/sdc/README.md)
