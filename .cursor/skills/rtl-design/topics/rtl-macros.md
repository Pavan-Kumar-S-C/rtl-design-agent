# Topic: RTL library macros

**Load when keywords:** macro, megafunction, ip catalog, km_hssi, library module, instantiate, reuse, altera ip, parameter editor, bitsync, vecsync, fifo ip, ram ip

**Standards:** [rtl-macros.md](../../../../docs/standards/rtl-macros.md) (router) · [megafunctions-ip-cores.md](../../../../docs/standards/megafunctions-ip-cores.md) (UG-01056 / **ug_intro_to_megafunctions**)

**Project catalog:** [rtl-macro-library.md](../../../../docs/design/rtl-macro-library.md) · [cdc-reusable-patterns.md](../../../../docs/design/cdc-reusable-patterns.md)

**PDF (opt-in):** [ug_intro_to_megafunctions-683102-848730.pdf](../../../../docs/standards/ug_intro_to_megafunctions-683102-848730.pdf)

**Examples:** [docs/examples/](../../../../../docs/examples/) for `km_hssi_*`

## Required: ask before reuse

| Match | Ask |
|-------|-----|
| IP Catalog / megafunction (RAM, FIFO, DSP, PLL, Insert Template) | IP core / megafunction vs custom RTL? |
| `km_hssi_*` in [rtl-macro-library.md](../../../../docs/design/rtl-macro-library.md) | Library macro vs custom/inline? |

Skip ask if user already named the IP core or macro module.
