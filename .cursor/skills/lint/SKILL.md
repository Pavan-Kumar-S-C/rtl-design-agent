---
name: lint
description: >-
  VC SpyGlass Lint for FPGA RTL: lint_rtl goal, block/initial_rtl methodology,
  synthesizability, connectivity, structure. Invoke @lint. For RTL coding rules
  use @rtl-design; for CDC verification use @cdc.
disable-model-invocation: true
---

# Lint (VC SpyGlass — FPGA)

**Invoke:** `@lint`

**Not this skill:** RTL style / write rules only → `@rtl-design` + [synthesizability-lint.md](../../../docs/standards/synthesizability-lint.md). CDC crossing verification → `@cdc`. List invokes → `@help`.

## What this skill covers

VC SpyGlass **Lint** for **FPGA synthesizable RTL**:

- Goal: **`lint_rtl`** with **`block/initial_rtl`** methodology
- Connectivity, simulation-quality, **synthesizability**, structural rules (multiple drivers, combinational loops, resets)
- App vars: `lint_clk_rst_node_latch`, `lint_clk_rst_node_on_pad`, tag configuration

**Out of scope:** `lint_netlist`, automotive/aerospace goals, emulation/formality goals, full UG verbatim without user request.

## Procedure

Follow [topic-router.md](topic-router.md) — **one** category or UG section at a time.

1. [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) — SpyGlass Lint row
2. [spyglass-lint-fpga.md](../../../docs/standards/spyglass-lint-fpga.md) — matched section
3. Company baseline: [synthesizability-lint.md](../../../docs/standards/synthesizability-lint.md)
4. Examples: [docs/examples/comb/](../../../docs/examples/comb/)

**PDF:** [vc_spyglass_lint_userguide.pdf](../../../docs/standards/vc_spyglass_lint_userguide.pdf) — opt-in per-tag reference.

## Conduct

- Base answers on standards + user lint reports / RTL. **Do not invent** waiver policy or disable tags without user approval.
- **Ask** when goal/methodology unclear or module is TB-only vs synthesizable.
- Prefer RTL fixes over `configure_lint_tag -disable` for FPGA sign-off categories.
- Separate facts from recommendations; cite section used.

## Related invokes

| Task | Invoke |
|------|--------|
| Write/review RTL coding rules | `@rtl-design` |
| CDC setup / crossing verification | `@cdc` |
| List all features | `@help` |

## Maintainer

- Router: [topic-router.md](topic-router.md)
- Summary: [docs/standards/spyglass-lint-fpga.md](../../../docs/standards/spyglass-lint-fpga.md)
