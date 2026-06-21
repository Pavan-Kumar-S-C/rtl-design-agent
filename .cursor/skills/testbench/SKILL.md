---
name: testbench
description: >-
  Generate complete self-checking Verilog/SystemVerilog testbenches for a single
  module or full DUT/top. Understands ports, timing, reset, handshakes, FSMs,
  FIFOs, protocols, corner cases, functional and negative tests (MAS assumptions).
  Avoids false failures. Invoke @testbench. For DUT RTL use @rtl-design.
disable-model-invocation: true
---

# Testbench generation

**Invoke:** `@testbench`

**Not this skill:** Write or refactor **synthesizable DUT RTL** → `@rtl-design`. SpyGlass CDC/Lint → `@cdc` / `@lint`. List invokes → `@help`.

## What this skill does

Expert **RTL verification** task: produce a **complete, correct, self-checking** testbench for:

1. A **single RTL module**, or
2. The **complete DUT / top-level** design.

You must understand RTL **functionality, ports, parameters, timing, reset, valid/ready handshakes, FSMs, counters, memories, FIFOs, protocols, and corner cases** before writing TB code.

The TB must verify **all intended functionality** with **functional (positive) test cases**, plus **negative test cases** that violate MAS assumptions or trigger documented failure/misbehavior — checking the DUT responds as specified.

The TB must **avoid false failures** and keep checking logic aligned with **actual** RTL timing, reset behavior, latency, and handshake conditions.

## Procedure

Follow [topic-router.md](topic-router.md) and [testbench-generation.md](../../../docs/standards/testbench-generation.md).

1. Read user RTL and **MAS** (if provided) — assumptions (A*) and failure modes (F*)
2. Ask **minimum** clarifications only when critical info is not inferable
3. Choose scope: unit module vs top DUT
4. Generate TB: clocks, reset, DUT instance, stimulus, checkers
5. **Functional tests** — happy path, main function, corners within assumptions
6. **Negative tests** — one per testable assumption/failure; check MAS-specified response
7. Self-review against false-failure rules

## Conduct

- Base behavior on **RTL + user spec**; infer only where RTL clearly defines timing/semantics
- **Do not invent** ports, protocol fields, or expected outputs without reference model or spec
- Match user language preference: Verilog, SystemVerilog, or UVM-lite
- Separate **facts** (from RTL) from **assumptions** (document in TB comments)
- Cite [testbench-generation.md](../../../docs/standards/testbench-generation.md) sections used

## Related invokes

| Task | Invoke |
|------|--------|
| DUT RTL write/review | `@rtl-design` |
| CDC verification | `@cdc` |
| Lint on DUT | `@lint` |
| IP simulation setup | `@rtl-design` + megafunctions § Simulation |

## Maintainer

- Standard: [docs/standards/testbench-generation.md](../../../docs/standards/testbench-generation.md)
- Router: [topic-router.md](topic-router.md)
