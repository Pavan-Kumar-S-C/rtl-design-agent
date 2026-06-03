# Topic router (agent procedure)

## Rule: guidelines + user input; ask only when in doubt

Before writing or changing RTL:

1. Use **coding guidelines** in `docs/standards/` and **user input** (prompt, open RTL, stated spec) as your sources of truth.
2. **Do not** load every standards file — match keywords when possible; use fallback when not (below).
3. **Do not invent** spec, ports, clocks, resets, or register maps.
4. **Ask the user** when you have **doubts** — ambiguous scope, missing dialect, unclear intent, or conflicting requirements. One clear question; wait if the answer changes the approach.
5. If you can proceed reasonably from guidelines + user input + visible RTL, **do not** block the task only because INDEX had no keyword row.

## Step 1 — Match topics

Read [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) and [docs/design/INDEX.md](../../../docs/design/INDEX.md).

Extract keywords from the **user message** and **open file names** (e.g. `fsm`, `cdc`, `bitsync`, `tod`, `km_xcvr`, `.v`).

Select **zero or more** topic/section rows.

## Step 2 — Load docs (selective)

For each match, read **only**:

1. The matched **design doc section** (`docs/design/*.md` — see Contents table) when INDEX lists a row
2. The `Standard file` from standards INDEX (generic rules)
3. [docs/examples/](../../../docs/examples/) files cited in design INDEX for that section

**Prefer design doc + examples** over generic standards when both match (e.g. CDC/ToD work).

**Quartus metastability / MTBF:** match `quartus`, `mtbf`, `metastability`, `synchronizer identification` → read matched section of [quartus-design-recommendations.md](../../../docs/standards/quartus-design-recommendations.md) and [metastability-mtbf.md](../../../docs/standards/metastability-mtbf.md); use [topics/quartus-metastability.md](topics/quartus-metastability.md). Open [Design Recommendations.pdf](../../../docs/standards/Design%20Recommendations.pdf) only if the user needs verbatim UG text.

**Timing Analyzer / SDC:** match `sdc`, `timing analyzer`, `timing cookbook`, `sta`, `setup`, `hold`, `multicycle`, `virtual clock`, `derive_pll`, `set_input_delay`, `set_output_delay`, `jtag`, `altera_reserved`, `get_fanouts`, `report_timing`, `cdc constraint` → use [topics/timing-analyzer.md](topics/timing-analyzer.md): **recipes** → INDEX **Cookbook** router + [timing-analyzer-cookbook.md](../../../docs/standards/timing-analyzer-cookbook.md); **concepts/reports/CDC SDC rules** → INDEX **Timing Analyzer UG** router + [timing-analyzer-ug.md](../../../docs/standards/timing-analyzer-ug.md). Examples: [docs/examples/sdc/](../../../docs/examples/sdc/). PDFs only when user wants verbatim text.

**Macros / megafunctions:** match `macro`, `megafunction`, `ip catalog`, `km_hssi`, `altera ip` → [rtl-macros.md](../../../docs/standards/rtl-macros.md); load [megafunctions-ip-cores.md](../../../docs/standards/megafunctions-ip-cores.md) for IP Catalog (source: **ug_intro_to_megafunctions-683102-848730.pdf**); load [rtl-macro-library.md](../../../docs/design/rtl-macro-library.md) for `km_hssi_*`. **Ask** IP megafunction vs custom RTL and/or library macro vs inline unless user already chose.

## Step 3 — Workflow files (conditional)

| Intent in user message | Read |
|------------------------|------|
| review, audit, checklist | [review-checklist.md](review-checklist.md) + `review-workflow.md` standard |
| write, implement, create, refactor | [design-workflow.md](design-workflow.md) |
| (unclear) | **Ask** write vs review vs explain |

## Step 4 — Topic skill stubs (optional)

Thin pointers under [topics/](topics/) — use if you need a one-screen reminder after loading the standard file.

## No INDEX match (fallback)

When **no** design or standards row matches keywords:

1. **Still apply** [coding guidelines](../../../docs/standards/) relevant to the task:
   - Any RTL write/review: [verilog-systemverilog-dialect.md](../../../docs/standards/verilog-systemverilog-dialect.md), [synthesizability-lint.md](../../../docs/standards/synthesizability-lint.md)
   - Add others only if the user’s words or open code clearly imply them (e.g. “FSM” → `fsm-coding.md`)
2. **Prioritize user input** — explicit requirements, pasted spec, open module interfaces, project style in neighboring files.
3. **Ask only if doubtful** — e.g. dialect unclear, CSR/CT22 in scope unknown, conflicting instructions, or missing ports/clocks/reset polarity needed for a correct answer.

Optional (not required before every edit):

> I didn’t match a design-doc section — proceeding with coding guidelines and your description. Confirm if you want a specific doc (CDC patterns, ToD analysis, etc.).

Do **not** refuse work solely because INDEX had no row.
