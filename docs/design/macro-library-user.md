# User macro library supplement (optional)

**Altera megafunctions / IP Catalog:** documented in [megafunctions-ip-cores.md](../standards/megafunctions-ip-cores.md) (source PDF: [ug_intro_to_megafunctions-683102-848730.pdf](../standards/ug_intro_to_megafunctions-683102-848730.pdf)).

Add **project-specific** macros (beyond `km_hssi_*`) in the table below.

## Template (fill in)

| Macro / module name | Category | When to use | Do not use when | Example path in repo |
|---------------------|----------|-------------|-----------------|----------------------|
| *(example)* `km_hssi_bitsync` | CDC bit | 1-bit async → sync | Multi-bit bus | `km_xcvr_common/.../km_hssi_bitsync.sv` |

After editing, add rows to [design/INDEX.md](INDEX.md) if you add new `##` sections.

**Maintainer:** After adding a PDF, run `python scripts/extract_macro_doc.py` and summarize new macros into this file or [rtl-macro-library.md](rtl-macro-library.md).
