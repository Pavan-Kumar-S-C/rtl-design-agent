# MAS documents

Add your **Micro Architecture Specification (MAS)** documents here.

## When to create MAS

After the **HAS** has been reviewed and understood, prepare the MAS **before** RTL implementation. The agent will not skip MAS unless you explicitly approve.

## Required MAS sections

Use [MAS-outline.md](MAS-outline.md) as a starting template. Every MAS must include:

1. **Scope** — block purpose, interfaces, clocks/resets  
2. **Assumptions** — all design assumptions  
3. **Failure / unexpected behavior** — conditions where the design may fail or behave unexpectedly  
4. **Functional description** — FSMs, pipelines, handshakes (implementation detail)  
5. **Debug strategy** — synthesizable hardware debug, switch-controlled, off by default  

## RTL rules tied to this MAS

- RTL comments reference MAS section numbers (e.g. `// MAS §3.2 — ...`)  
- Ports: inputs `i_*`, outputs `o_*`  
- Debug logic: synthesizable, enabled only when required  

Standard: `rtl-design-agent` → `docs/standards/mas-rtl-workflow.md` (loaded by `@rtl-design`).

This folder is registered as `paths.mas_dir` in `rtl_db/index.yaml`.
