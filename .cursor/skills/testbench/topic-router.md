# Topic router — @testbench

## Rule: understand RTL first; minimum questions; no false failures

1. Read open RTL and user message — ports, clocks, resets, handshakes, FSMs, memories, FIFOs.
2. Load [testbench-generation.md](../../../docs/standards/testbench-generation.md) — **one** section matching task phase (analysis → structure → checking → deliverables).
3. **Do not invent** protocol timing, reset polarity, or expected outputs.
4. **Do not** write synthesizable DUT logic — redirect to `@rtl-design`.
5. Ask only when **critical** info is missing (see standard § Minimum clarification questions).

## Step 0 — Classify scope

| User says | TB scope |
|-----------|----------|
| single module, unit test, block-level | Instantiate **one** module; stub or tie off interfaces |
| top, DUT, chip, system, full design | Instantiate **top**; include required wrappers/models |
| Unclear | **Ask:** unit module or full top? |

## Step 1 — RTL analysis (mandatory before coding)

Extract and document (mentally or in TB header comment):

| Item | Source |
|------|--------|
| Module name(s), parameters | `module` / `parameter` / `localparam` |
| Clock edges | `always @(posedge/negedge …)` |
| Reset type and polarity | `rst`, `reset_n`, async/sync release |
| Handshakes | `valid`/`ready`, `req`/`ack`, enable patterns |
| Latency | Pipeline registers, FIFO depth, FSM states |
| Memories / FIFOs | Read/write timing, full/empty flags |
| Protocols | Bus signals — match RTL FSM only unless user gives spec |

If clock period or reset hold is **not** in RTL → ask user **once** with suggested default in question.

## Step 2 — Language and simulator

| Keywords | Action |
|----------|--------|
| verilog, .v TB | Verilog-2001 style TB |
| systemverilog, .sv TB, interface, class | SystemVerilog TB (default for `.sv` DUT) |
| uvm, uvm-lite, agent, monitor | UVM-lite structure (no full UVM unless requested) |
| verilator, vcs, questa, xcelium, modelsim | Adapt plusargs / timescale / dump syntax |

Load [verilog-systemverilog-dialect.md](../../../docs/standards/verilog-systemverilog-dialect.md) when dialect unclear.

## Step 3 — Generate TB components

Order of creation:

1. Parameters / defines / timescale
2. Clock and reset generators (document period and reset cycles)
3. DUT instantiation (parameter map matches user RTL)
4. Interfaces / wire declarations
5. Reference model or expected-data queue (if spec exists)
6. Stimulus tasks / tests
7. Checkers — aligned to latency and handshakes ([testbench-generation.md](../../../docs/standards/testbench-generation.md) § Checking rules)
8. Timeout watchdog
9. `initial` test runner → summary → `$finish`

## Step 4 — Test plan (minimum)

| Test | Purpose |
|------|---------|
| `test_reset` | Assert reset, release, idle state, no false compare during reset |
| `test_sanity` | Single happy-path transaction |
| `test_main` | Primary function per RTL/spec |
| `test_corner` | At least one: back-pressure, empty/full, reset-during-busy, max counter, etc. |

Add tests only for behavior **evident** in RTL or user spec.

## Step 5 — False-failure review

Before delivering, verify:

- [ ] No output checks before reset release + settle
- [ ] Compare queues delayed by pipeline depth
- [ ] Handshake samples on correct cycle
- [ ] Multi-bit buses compared only when valid/ready complete
- [ ] PASS/FAIL based on error counter, not dump presence

## Step 6 — IP / megafunction DUT

If DUT instantiates Intel/Altera IP → load [megafunctions-ip-cores.md](../../../docs/standards/megafunctions-ip-cores.md) § Simulation; do not hand-roll encrypted model behavior.

## Redirects

| User intent | Invoke |
|-------------|--------|
| Write/fix DUT RTL | `@rtl-design` |
| SpyGlass CDC on DUT | `@cdc` |
| Lint DUT | `@lint` |
