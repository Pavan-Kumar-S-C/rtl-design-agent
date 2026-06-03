# Design source documents

Authoritative project patterns live here. Each file has a **Contents** list and `##` sections.

## Current documents

| File | Description |
|------|-------------|
| [cdc-reusable-patterns.md](cdc-reusable-patterns.md) | KM XCVR CDC library patterns + instantiation templates |
| [architecture-comparison.md](architecture-comparison.md) | Legacy ToD synchronizer vs km_xcvr_mps_tod_counter |
| [km-xcvr-tod-analysis.md](km-xcvr-tod-analysis.md) | New ToD counter synchronization analysis |
| [legacy-tod-sync-analysis.md](legacy-tod-sync-analysis.md) | Legacy `altera_eth_1588_tod_synchronizer` CDC and Quartus attributes |
| [rtl-macro-library.md](rtl-macro-library.md) | `km_hssi_*` macro catalog — **ask user** before instantiate |
| [macro-library-user.md](macro-library-user.md) | Optional project-specific macro table |
| Megafunctions UG | [megafunctions-ip-cores.md](../standards/megafunctions-ip-cores.md) ← `ug_intro_to_megafunctions-683102-848730.pdf` |

**Section router:** [INDEX.md](INDEX.md) — keywords → which `##` section to read.

**Extracted RTL:** [docs/examples/](../examples/) (`.v` / `.sv` per section).

## Add another document

1. Add `your-guide.md` with **Contents** + `##` sections.
2. Add rows to [INDEX.md](INDEX.md).
3. Copy code blocks into `docs/examples/<topic>/`.
