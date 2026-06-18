---
name: rtl-coding-standards
description: >-
  Verilog/SystemVerilog RTL coding and review. Selective topic load via
  docs/standards/INDEX.md — FSM, CDC, resets, lint, CSR, CT22. Guidelines +
  user input; ask only when in doubt. Same router as @rtl-design.
disable-model-invocation: true
---

# RTL coding standards

**Invoke:** `@rtl-coding-standards` (alias of `@rtl-design`)

For timing reports use `@timing-analysis`; for SDC use `@sdc`; for all invokes use `@help`.

Use the same procedure as [@rtl-design](../rtl-design/SKILL.md):

1. [topic-router.md](../rtl-design/topic-router.md)
2. [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) — keyword match only
3. Load matched topic files and design doc **sections** only

Use coding guidelines + **user input**; follow [topic-router.md](../rtl-design/topic-router.md) including **no-match fallback**. **Ask only when in doubt.**
