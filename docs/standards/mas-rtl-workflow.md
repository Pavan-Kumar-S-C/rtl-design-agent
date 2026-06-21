# MAS and RTL implementation workflow

**Keywords:** `mas`, `has`, `micro architecture`, `assumption`, `failure mode`, `debug logic`, `mas section`, `i_`, `o_`, port naming, traceability comment

**Invoke:** `@rtl-design` (lifecycle + RTL write/review). **Not** SpyGlass / SDC / testbench-only tasks.

## HAS → MAS → RTL sequence

1. **Review and understand HAS** — extract requirements; flag gaps as `TBD`; do not start RTL until HAS is understood.
2. **Prepare MAS for RTL implementation** — after HAS review, author or update the **Micro Architecture Specification (MAS)** before writing or updating RTL.
3. **RTL implements MAS** — generated or hand-written RTL must trace to MAS sections (comments + database traceability).

Do **not** skip MAS and implement directly from HAS unless the user explicitly approves that shortcut.

## MAS required content

Every MAS document (or module-level MAS section) must include:

| Section | Content |
|---------|---------|
| **Scope** | What the block does; interfaces; clock/reset domains |
| **Assumptions** | All design assumptions (traffic patterns, rates, ordering, reset sequencing, external behavior) |
| **Failure / unexpected behavior** | Conditions under which the design may fail, deadlock, violate protocol, or behave unexpectedly |
| **Functional description** | State machines, pipelines, counters, handshakes — implementation detail for RTL |
| **Debug strategy** | Which observability is needed in hardware and how it is enabled |

Mark unknowns `TBD` and ask the user — do not invent assumptions.

## Port naming (RTL write/update)

When **writing or updating** RTL:

- **All input ports:** `i_<name>` (e.g. `i_clk`, `i_rst_n`, `i_data_valid`)
- **All output ports:** `o_<name>` (e.g. `o_data`, `o_ready`)

Apply to module ports and to internal hierarchy where the project convention extends to submodule connections. Match existing top-level net names only when integrating with legacy blocks — document exceptions in MAS.

## MAS traceability in RTL comments

RTL must include comments that identify **which MAS section** each major block implements.

```verilog
// MAS §3.2 — Packet header parser FSM
// MAS §4.1 — Assumption: i_pkt_valid held until o_pkt_ready asserts
always_ff @(posedge i_clk) begin
  ...
end
```

Rules:

- Comment at **module header** with MAS document + revision if known.
- Comment each **FSM**, **pipeline stage**, **CDC crossing**, and **logic block >5 lines** with the matching MAS `§` reference.
- If RTL implements behavior not described in MAS — **stop** and update MAS first (or flag as `TBD` and ask).

## Synthesizable debug logic

Add **hardware debug observability** in RTL to help identify failure/unexpected-behavior conditions documented in the MAS.

| Rule | Detail |
|------|--------|
| **Synthesizable** | Debug logic must synthesize and be present in hardware (no `#delay`, no simulation-only constructs in the debug path) |
| **Switch-controlled** | Enable via a parameter, `localparam`, or static configuration port (e.g. `i_dbg_enable` or compile-time `` `ifdef DBG ``) |
| **Inactive by default** | Normal operation: debug must not change functional behavior or timing-critical paths |
| **MAS-mapped** | Each debug feature traces to a MAS failure/assumption (comment with `MAS §`) |
| **Lint-safe** | No latch inference; tie off or clock-gate debug outputs when disabled per project lint rules |

Example pattern:

```systemverilog
// MAS §5.3 — Debug: expose FSM state when i_dbg_enable asserted (default 0)
assign o_dbg_fsm_state = i_dbg_enable ? r_fsm_state : '0;
```

Prefer status counters, sticky error flags, and muxed observability outputs over invasive logic changes. Document debug port list in MAS and module port list.

## Lifecycle integration

- **Requirement extraction:** HAS → requirements; MAS → implementation detail and assumptions ([rtl-database-schema.md](rtl-database-schema.md)).
- **RTL generation (gated):** Only after MAS exists and database is validated ([dev-verify-workflow.md](../../.cursor/skills/rtl-design/dev-verify-workflow.md)).
- **Review:** [review-checklist.md](../../.cursor/skills/rtl-design/review-checklist.md) — port naming, MAS comments, debug switch default off.
- **Verification:** `@testbench` — functional tests + negative tests per MAS assumption/failure ID.

## Related standards

- [testbench-generation.md](testbench-generation.md) — functional + negative tests from MAS assumptions/failures
- [constants-structure.md](constants-structure.md) — parameters, intent comments, module size
- [rtl-database-schema.md](rtl-database-schema.md) — requirements and traceability YAML
- [synthesizability-lint.md](synthesizability-lint.md) — debug logic must remain synthesizable
