# Topic router (agent procedure)

## Rule: guidelines + user input; ask only when in doubt

Before writing or changing RTL:

1. Use **coding guidelines** in `docs/standards/` and **user input** (prompt, open RTL, stated spec) as your sources of truth.
2. **Do not** load every standards file — match keywords when possible; use fallback when not (below).
3. **Do not invent** spec, ports, clocks, resets, or register maps.
4. **Ask the user** when you have **doubts** — ambiguous scope, missing dialect, unclear intent, or conflicting requirements. One clear question; wait if the answer changes the approach.
5. If you can proceed reasonably from guidelines + user input + visible RTL, **do not** block the task only because INDEX had no keyword row.

## Separate invokes (not @rtl-design)

| User intent | Tell user to invoke |
|-------------|---------------------|
| STA, timing reports, slack, MTBF analysis | `@timing-analysis` |
| Write/review `.sdc`, constraint recipes | `@sdc` |
| SpyGlass CDC (`check_cdc`, SETUP_*, CDC_UNSYNC) | `@cdc` |
| SpyGlass Lint (`check_lint`, `lint_rtl`) | `@lint` |
| Testbench / scoreboard / self-checking sim | `@testbench` |
| List available features | `@help` |

Do **not** load Timing Analyzer UG, Cookbook, or `examples/sdc/` under `@rtl-design` — **no exceptions**. Full deny list: [rtl-design-exclusions.md](rtl-design-exclusions.md). Redirect the user to `@timing-analysis` or `@sdc`; do not load those skill files yourself.

Registry: [invoke-registry.md](../invoke-registry.md).

## Step 0 — Coding vs lifecycle intent

Before topic matching, classify intent:

- **Lifecycle mode** when keywords match: `has`, `mas`, `requirement`, `rtl database`, `rtl_db`, `traceability`, `traceability matrix`, `gap analysis`, `coverage`, `generate from spec`, `verify rtl`, `requirement coverage`, `consistency check`. Run [dev-verify-workflow.md](dev-verify-workflow.md) (workspace assessment first; gated decision flow). Load lifecycle topic stubs [topics/requirements.md](topics/requirements.md), [topics/rtl-database.md](topics/rtl-database.md), [topics/traceability.md](topics/traceability.md) and schema [docs/standards/rtl-database-schema.md](../../../docs/standards/rtl-database-schema.md). Coding-standards topic matching (Steps 1-2) still applies when generating RTL.
- **Coding mode** otherwise — continue with Step 1.

## Step 1 — Match topics

Read [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) and [docs/design/INDEX.md](../../../docs/design/INDEX.md).

Extract keywords from the **user message** and **open file names** (e.g. `fsm`, `cdc`, `bitsync`, `tod`, `km_xcvr`, `.v`).

Select **zero or more** topic/section rows.

**Skip under `@rtl-design`:** INDEX rows **Timing Analyzer / SDC**, **Timing Analyzer Cookbook**, **SpyGlass CDC**, **SpyGlass Lint**, **Testbench generation** — never match; see [rtl-design-exclusions.md](rtl-design-exclusions.md). If the prompt is **only** timing/SDC/SpyGlass keywords, redirect before loading anything else.

## Step 2 — Load docs (selective)

For each match, read **only**:

1. The matched **design doc section** (`docs/design/*.md` — see Contents table) when INDEX lists a row
2. The `Standard file` from standards INDEX (generic rules)
3. [docs/examples/](../../../docs/examples/) files cited in design INDEX for that section

**Prefer design doc + examples** over generic standards when both match (e.g. CDC/ToD work).

**Quartus metastability / MTBF (RTL attributes only):** match in **RTL context** → [quartus-design-recommendations.md](../../../docs/standards/quartus-design-recommendations.md) (RTL attribute sections), [metastability-mtbf.md](../../../docs/standards/metastability-mtbf.md), [topics/quartus-metastability.md](topics/quartus-metastability.md). **Do not** load UG/Cookbook. For `report_metastability`, MTBF reports, or SDC → tell user to invoke `@timing-analysis` / `@sdc`.

**Quartus module build (synthesis):** match `quartus`, `synthesis`, `compile`, `qpf`, `qsf`, `qshell` **only when the user explicitly requested that step** → [quartus-module-build.md](../../../docs/standards/quartus-module-build.md), [topics/quartus-module-build.md](topics/quartus-module-build.md). Use existing workspace `.qpf` and qshell/PATH — **do not** create `quartus/module_build/` by default. Fit/STA → `@timing-analysis`.

**Macros / megafunctions:** match `macro`, `megafunction`, `ip catalog`, `km_hssi`, `altera ip` → [rtl-macros.md](../../../docs/standards/rtl-macros.md); load [megafunctions-ip-cores.md](../../../docs/standards/megafunctions-ip-cores.md) for IP Catalog (source: **ug_intro_to_megafunctions-683102-848730.pdf**); load [rtl-macro-library.md](../../../docs/design/rtl-macro-library.md) for `km_hssi_*`. **Ask** IP megafunction vs custom RTL and/or library macro vs inline unless user already chose.

## Step 3 — Workflow files (conditional)

| Intent in user message | Read |
|------------------------|------|
| review, audit, checklist | [review-checklist.md](review-checklist.md) + `review-workflow.md` standard |
| write, implement, create, refactor | [design-workflow.md](design-workflow.md) |
| requirements, database, traceability, generate-from-spec, verify (lifecycle) | [dev-verify-workflow.md](dev-verify-workflow.md) + [rtl-database-schema.md](../../../docs/standards/rtl-database-schema.md) |
| synthesis, quartus compile, qsf, qshell, module quartus build (explicit request only) | [quartus-module-build.md](../../../docs/standards/quartus-module-build.md) |
| (unclear) | **Ask** write vs review vs lifecycle vs explain |

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
