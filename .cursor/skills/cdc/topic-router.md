# Topic router — @cdc

## Rule: one goal file per task

1. Classify goal from user keywords (Step 1).
2. Load **exactly one** file from [docs/standards/spyglass-cdc/](../../../docs/standards/spyglass-cdc/) — not the index and not multiple goal files unless user spans goals.
3. Index [spyglass-cdc-fpga.md](../../../docs/standards/spyglass-cdc-fpga.md) — flow/prerequisites only; do not load goal detail from it when a goal file matches.
4. **Do not invent** clock names, reset trees, or waiver text.
5. RTL synchronizer fixes → `@rtl-design`. SDC authoring → `@sdc`.

## Step 1 — Classify goal → file

| User keywords | Goal | Load file | Primary command |
|---------------|------|-----------|-----------------|
| setup, read_sdc, create_clock, create_reset, infer_setup, SETUP_, configure_cdc_setup_check, setup violation | `cdc_setup` / `cdc_setup_check` | [cdc_setup.md](../../../docs/standards/spyglass-cdc/cdc_setup.md) | `check_cdc -type setup` |
| reset integrity, async reset crossing, CDC_UNSYNC_ASYNCRESET, preset, clear crossing | `cdc_reset_integrity` | [cdc_reset_integrity.md](../../../docs/standards/spyglass-cdc/cdc_reset_integrity.md) | `check_cdc -type sync` |
| cdc verify, synchronizer, CDC_UNSYNC, CDC_SYNC, NFF, blocking gate, qualifier, integ | `cdc_verify` | [cdc_verify.md](../../../docs/standards/spyglass-cdc/cdc_verify.md) | `check_cdc -type sync` |
| struct, convergence, glitch, check_cdc struct, SETUP_CLOCK_GLITCH | `cdc_verify_struct` | [cdc_verify_struct.md](../../../docs/standards/spyglass-cdc/cdc_verify_struct.md) | `check_cdc -type struct` |
| abstract, SAM, hierarchical, create_cdc_abstract_model, write_abstract_model, set_abstract_model | `cdc_abstract` | [cdc_abstract.md](../../../docs/standards/spyglass-cdc/cdc_abstract.md) | SAM flow |

Multi-goal tasks: follow FPGA order setup → sync (verify + reset) → struct → abstract; load **one file at a time** per sub-question.

## Step 2 — Cross-loads

| Need | Load |
|------|------|
| Flow / which goal applies | [spyglass-cdc-fpga.md](../../../docs/standards/spyglass-cdc-fpga.md) (index only) |
| Fix synchronizer RTL | `@rtl-design` [cdc-crossings.md](../../../docs/standards/cdc-crossings.md) + [cdc-reusable-patterns.md](../../../docs/design/cdc-reusable-patterns.md) |
| Fix SDC / missing clocks | `@sdc` |
| MTBF / chain depth reporting | `@timing-analysis` |

## Step 3 — PDF (opt-in)

[VC_SpyGlass_CDC_UserGuide.pdf](../../../docs/standards/VC_SpyGlass_CDC_UserGuide.pdf) — verbatim tag text when goal file is insufficient:

| PDF chapter | Goal file |
|-------------|-----------|
| Ch. 3 | cdc_setup.md |
| Ch. 5 | cdc_verify.md, cdc_verify_struct.md |
| Ch. 6 | cdc_reset_integrity.md |
| Ch. 9 | cdc_abstract.md |

Extract: [_spyglass_cdc_extract_raw.txt](../../../docs/standards/_spyglass_cdc_extract_raw.txt) — partial backup.

## Redirects

| User intent | Invoke |
|-------------|--------|
| Write 2FF / gray / FIFO RTL | `@rtl-design` |
| Author `.sdc` | `@sdc` |
| SpyGlass lint | `@lint` |
