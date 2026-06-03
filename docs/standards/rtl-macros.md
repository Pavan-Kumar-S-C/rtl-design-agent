# Reusable macros (IP megafunctions + project library)

**Keywords:** `macro`, `megafunction`, `ip catalog`, `library module`, `km_hssi`, `instantiate`, `reuse`, `altera ip`, `parameter editor`

## Agent behavior (required)

**Ask the user** before using any documented reuse path, unless they already named it in the prompt.

### A — Altera IP Catalog / megafunctions

When RAM, FIFO, DSP, PLL, memory controller, or **Insert Template** inferred logic could apply:

1. Suggest the **IP Catalog** or **inferred megafunction** approach per [megafunctions-ip-cores.md](megafunctions-ip-cores.md).
2. **Ask:** use **IP Catalog / megafunction (generate `.ip`/`.qip`)** or **custom RTL**?
3. Do not copy files from `/quartus/libraries/megafunctions` or add generated `.v` without `.ip`/`.qip`.

### B — Project CDC library (`km_hssi_*`)

When [rtl-macro-library.md](../design/rtl-macro-library.md) matches:

1. Name candidate macro(s).
2. **Ask:** use **`km_hssi_*` library macro** or **custom/inline** logic?
3. If user declines, do not instantiate `km_hssi_*`.

**Do not invent** IP core names, parameters, or file paths.

## Catalog

| Resource | Use |
|----------|-----|
| [megafunctions-ip-cores.md](megafunctions-ip-cores.md) | **ug_intro_to_megafunctions** — IP Catalog, Parameter Editor, best practices |
| [ug_intro_to_megafunctions-683102-848730.pdf](ug_intro_to_megafunctions-683102-848730.pdf) | Verbatim UG-01056 (opt-in) |
| [rtl-macro-library.md](../design/rtl-macro-library.md) | Project `km_hssi_*` index + selection guide |
| [cdc-reusable-patterns.md](../design/cdc-reusable-patterns.md) | Full CDC interfaces (section load) |
| [macro-library-user.md](../design/macro-library-user.md) | Optional project-specific additions |

**Section routing:** [INDEX.md](INDEX.md) (megafunctions + design INDEX for `km_hssi`).

## Related standards

- CDC rules: [cdc-crossings.md](cdc-crossings.md)
- Quartus synchronizer attributes: [quartus-design-recommendations.md](quartus-design-recommendations.md)
- STA / CDC constraints: [timing-analyzer-ug.md](timing-analyzer-ug.md)
