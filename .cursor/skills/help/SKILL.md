---
name: help
description: >-
  List all RTL Design Agent invoke names and what each does. Use when the user
  types help, asks what skills are available, what to invoke, list commands,
  or @help.
disable-model-invocation: true
---

# Help — available invokes

**Invoke:** `@help` (or type **help** in Agent chat with this skill)

## Behavior

1. Read [invoke-registry.md](../invoke-registry.md) — **single source of truth**.
2. Reply with the **Quick picker** table and the full **Invoke registry** table from that file.
3. Do not invent invokes not listed in the registry.
4. If the user asks about a specific invoke, expand that row only.

## When to suggest another invoke

| User wants… | Point them to |
|-------------|---------------|
| RTL write/review, HAS/MAS, traceability | `@rtl-design` |
| Timing reports, STA, slack, MTBF analysis | `@timing-analysis` |
| SDC files, constraint recipes | `@sdc` |
| SpyGlass CDC verification | `@cdc` |
| SpyGlass Lint (FPGA RTL) | `@lint` |
| Self-checking simulation testbench | `@testbench` |

## Maintainer

When adding a skill, update [invoke-registry.md](../invoke-registry.md) in the same change.
