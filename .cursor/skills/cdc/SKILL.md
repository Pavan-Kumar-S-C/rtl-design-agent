---
name: cdc
description: >-
  VC SpyGlass CDC verification for FPGA: cdc_setup, cdc_setup_check,
  cdc_reset_integrity, cdc_verify, cdc_abstract, cdc_verify_struct.
  Invoke @cdc. For writing synchronizer RTL use @rtl-design; for SDC use @sdc.
disable-model-invocation: true
---

# CDC verification (VC SpyGlass)

**Invoke:** `@cdc`

**Not this skill:** RTL synchronizer design → `@rtl-design`. SDC / clocks → `@sdc`. STA / MTBF reports → `@timing-analysis`. List invokes → `@help`.

## In-scope goals only

| Goal | SpyGlass phase |
|------|----------------|
| `cdc_setup` | `read_sdc`; `check_cdc -type setup` |
| `cdc_setup_check` | Debug `SETUP_*` tags |
| `cdc_reset_integrity` | `check_cdc -type sync` — `CDC_UNSYNC_ASYNCRESET` |
| `cdc_verify` | `check_cdc -type integ` (opt), `check_cdc -type sync` |
| `cdc_abstract` | SAM: `create_cdc_abstract_model`, `write_abstract_model` |
| `cdc_verify_struct` | `check_cdc -type struct` — convergence / glitch |

**Out of scope:** RDC-only flows, goals not listed above, full UG verbatim without user request.

## Procedure

Follow [topic-router.md](topic-router.md) — load **one** goal file from [docs/standards/spyglass-cdc/](../../../docs/standards/spyglass-cdc/) per task.

1. [docs/standards/INDEX.md](../../../docs/standards/INDEX.md) — SpyGlass CDC row
2. Index: [spyglass-cdc-fpga.md](../../../docs/standards/spyglass-cdc-fpga.md) (flow only)
3. Goal file: `cdc_setup.md` | `cdc_reset_integrity.md` | `cdc_verify.md` | `cdc_verify_struct.md` | `cdc_abstract.md`
4. When fixing RTL: `@rtl-design` + [cdc-crossings.md](../../../docs/standards/cdc-crossings.md)

**PDF:** [VC_SpyGlass_CDC_UserGuide.pdf](../../../docs/standards/VC_SpyGlass_CDC_UserGuide.pdf) — opt-in per-tag debug only.

## Conduct

- Base answers on standards + user SpyGlass reports / SDC / RTL. **Do not invent** clocks, resets, or waiver rationale.
- **Ask** when SDC is missing, goal is ambiguous, or setup is not clean before verify.
- FPGA: do not sign off on `infer_setup` alone — use verified Quartus/Intel SDC.
- Separate facts from recommendations; cite goal section used.

## Related invokes

| Task | Invoke |
|------|--------|
| Write/review synchronizer RTL | `@rtl-design` |
| Write/review `.sdc` | `@sdc` |
| MTBF / `report_metastability` | `@timing-analysis` |
| Lint / synthesizability | `@lint` |
| List all features | `@help` |

## Maintainer

- Router: [topic-router.md](topic-router.md)
- Summary: [docs/standards/spyglass-cdc-fpga.md](../../../docs/standards/spyglass-cdc-fpga.md) (index) + [docs/standards/spyglass-cdc/](../../../docs/standards/spyglass-cdc/) goal files
