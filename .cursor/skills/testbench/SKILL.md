---
name: testbench
description: >-
  Generate complete self-checking Verilog/SystemVerilog testbenches for a single
  module or full DUT/top. Understands ports, timing, reset, handshakes, FSMs,
  FIFOs, protocols, corner cases. Avoids false failures. Invoke @testbench.
  For DUT RTL use @rtl-design.
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

The TB must verify **all intended functionality**, **avoid false failures**, and keep checking logic aligned with **actual** RTL timing, reset behavior, latency, and handshake conditions. Correct waveforms must not produce incorrect FAIL/ERROR in the log.

## Procedure

Follow [topic-router.md](topic-router.md) and [testbench-generation.md](../../../docs/standards/testbench-generation.md).

1. Read user RTL (and spec if provided) — **do not assume** clocks, resets, or protocol details not in RTL or user input
2. Ask **minimum** clarifications only when critical info is not inferable
3. Choose scope: unit module vs top DUT
4. Generate TB: clocks, reset, DUT instance, stimulus, checkers, tests, pass/fail summary
5. Self-review against false-failure rules (reset settle, pipeline latency, handshake sampling)

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
